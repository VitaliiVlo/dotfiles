#!/usr/bin/env python3
"""Each run reads the clean base for each tracked file in `TARGETS` from `git show HEAD:<path>`
so overrides apply against a known starting point and never compound. The resulting
working-tree diff is intentional and must stay uncommitted.
"""

from __future__ import annotations

import json
import re
import shlex
import shutil
import subprocess
import sys

try:
    import tomllib
except ModuleNotFoundError:  # Python < 3.11
    raise SystemExit("local-overrides.py requires Python 3.11+ (stdlib tomllib)")

from pathlib import Path
from typing import NoReturn

REPO = Path(__file__).resolve().parent.parent
SOURCE = REPO / ".local/source.toml"
EXAMPLE = REPO / ".local.example.toml"

TARGETS = {
    "claude": REPO / ".config/claude/settings.json",
    "codex": REPO / ".config/codex/config.toml",
    "git": REPO / ".config/git/config",
    "zprofile": REPO / ".zprofile",
    "zshrc": REPO / ".zshrc",
}

# Marketplaces the CLI binary pre-registers; plugin references resolve through them
# without an explicit declaration, and re-declaring one is an error.
CLAUDE_BUILTIN_MARKETS = {"claude-plugins-official"}
CODEX_BUILTIN_MARKETS = {"openai-curated"}

ALIAS_START = "# >>> local-overrides:aliases >>>"
ALIAS_END = "# <<< local-overrides:aliases <<<"
ALIAS_NAME_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_.-]*")


def die(msg: str) -> NoReturn:
    print(f"local-overrides: {msg}", file=sys.stderr)
    sys.exit(1)


def head_base(path: Path) -> str:
    """Return the file's content at HEAD. Hard-fail if the path is not tracked,
    because the working copy may already contain rendered overrides from a prior
    run, and rendering on top would compound them silently."""
    rel = path.relative_to(REPO).as_posix()
    try:
        return subprocess.check_output(
            ["git", "-C", str(REPO), "show", f"HEAD:{rel}"],
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except subprocess.CalledProcessError:
        die(
            f"HEAD:{rel} missing. Commit the new target path before running "
            "local-overrides; working-copy base would risk compounding overrides."
        )


def _toml_key(key: str) -> str:
    """Bare TOML key when safe, else a quoted basic string (json.dumps escape rules match)."""
    return key if re.fullmatch(r"[A-Za-z0-9_-]+", key) else json.dumps(key)


def _market_git_url(key: str, m: dict) -> str:
    """Resolve a marketplace table to a git URL for Codex's `source_type = "git"` form.
    Accepts the same `repo` (GitHub) / `url` (raw git) fields as the Claude schema."""
    if m.get("url"):
        return m["url"]
    if m.get("repo"):
        return f"https://github.com/{m['repo']}.git"
    die(f"codex.marketplaces.{key} needs 'repo' (github) or 'url' (git)")


def _check_plugin_id(pid: str, known: set[str], tool: str) -> None:
    if "@" not in pid:
        die(f"{tool} plugin must be 'name@marketplace': {pid!r}")
    market = pid.rsplit("@", 1)[1]
    if market not in known:
        die(
            f"{tool} plugin {pid!r} references unknown marketplace {market!r}; "
            f"declare it under [{tool}.marketplaces.{market}]"
        )


def render_claude(base: str, claude: dict) -> str:
    data = json.loads(base)
    markets = claude.get("marketplaces", {}) or {}
    plugins = claude.get("plugins", []) or []

    data.setdefault("extraKnownMarketplaces", {})
    for key, m in markets.items():
        entry = {
            "source": {"source": m.get("source", "github")},
            "autoUpdate": bool(m.get("auto_update", True)),
        }
        if "repo" in m:
            entry["source"]["repo"] = m["repo"]
        if "url" in m:
            entry["source"]["url"] = m["url"]
        data["extraKnownMarketplaces"][key] = entry

    data.setdefault("enabledPlugins", {})
    known = set(data["extraKnownMarketplaces"]) | set(markets) | CLAUDE_BUILTIN_MARKETS
    for pid in plugins:
        _check_plugin_id(pid, known, "claude")
        data["enabledPlugins"][pid] = True

    return json.dumps(data, indent=2) + "\n"


def render_codex(base: str, codex: dict) -> str:
    markets = codex.get("marketplaces", {}) or {}
    plugins = list(dict.fromkeys(codex.get("plugins", []) or []))
    if not markets and not plugins:
        return base

    try:
        parsed = tomllib.loads(base)
    except tomllib.TOMLDecodeError as e:
        die(f"HEAD:.config/codex/config.toml is not valid TOML: {e}")
    in_base_markets = set(parsed.get("marketplaces", {}))
    in_base_plugins = set(parsed.get("plugins", {}))
    known = in_base_markets | set(markets) | CODEX_BUILTIN_MARKETS

    blocks = []
    for key, m in markets.items():
        if key in CODEX_BUILTIN_MARKETS:
            die(f"codex marketplace {key!r} is a CLI built-in; do not declare it")
        if key in in_base_markets:
            continue  # already tracked in config.toml
        url = _market_git_url(key, m)
        blocks.append(
            f"[marketplaces.{_toml_key(key)}]\nsource_type = \"git\"\nsource = {json.dumps(url)}"
        )

    for pid in plugins:
        _check_plugin_id(pid, known, "codex")
        if pid in in_base_plugins:
            continue  # already enabled in config.toml
        blocks.append(f"[plugins.{json.dumps(pid)}]\nenabled = true")

    if not blocks:
        return base
    header = "\n# Team marketplaces + plugins (rendered from .local/source.toml)"
    return base.rstrip() + "\n" + header + "\n" + "\n\n".join(blocks) + "\n"


def render_git(base: str, git: dict) -> str:
    email = git.get("email")
    name = git.get("name")
    if not email and not name:
        return base
    block = ["[user]"]
    if email:
        block.append(f"\temail = {email}")
    if name:
        block.append(f"\tname = {name}")
    replacement = "\n".join(block) + "\n\n"
    # Match `[user]` header through (but not including) the next line-anchored
    # section header. Lookahead-anchored stop boundary survives `[` characters
    # inside email/name values (e.g. `Foo [bot]`).
    # Lambda replacement so backslash sequences in email/name are not interpreted as regex backrefs.
    new, n = re.subn(
        r"^\[user\](?:(?!^\[).)*",
        lambda _: replacement,
        base,
        count=1,
        flags=re.M | re.S,
    )
    if n != 1:
        die(
            ".config/git/config has no `[user]` block to replace. "
            "Restore the placeholder block before running local-overrides."
        )
    return new


def render_zprofile(base: str, go: dict) -> str:
    private = go.get("private", "")
    if not private:
        return base
    # Match any `export GOPRIVATE=...` form (quoted or not). Lambda replacement
    # so backslash sequences in `private` are not interpreted as regex backrefs.
    new, n = re.subn(
        r"^export GOPRIVATE=.+$",
        lambda _: f'export GOPRIVATE="{private}"',
        base,
        count=1,
        flags=re.M,
    )
    if n != 1:
        die(
            ".zprofile has no `export GOPRIVATE=...` line to replace. "
            "Restore the placeholder line before running local-overrides."
        )
    return new


def render_aliases(base: str, aliases: dict) -> str:
    if not aliases:
        return base
    lines = []
    for name, cmd in aliases.items():
        if not ALIAS_NAME_RE.fullmatch(name):
            die(f"alias name {name!r} is not a valid shell alias identifier")
        if not isinstance(cmd, str):
            die(f"alias {name!r} value must be a string, got {type(cmd).__name__}")
        lines.append(f"alias {name}={shlex.quote(cmd)}")
    replacement = ALIAS_START + "\n" + "\n".join(lines) + "\n" + ALIAS_END
    new, n = re.subn(
        re.escape(ALIAS_START) + r".*?" + re.escape(ALIAS_END),
        lambda _: replacement,
        base,
        count=1,
        flags=re.S,
    )
    if n != 1:
        die(
            ".zshrc has no local-overrides alias marker block to fill. "
            f"Restore the `{ALIAS_START}` / `{ALIAS_END}` lines before running local-overrides."
        )
    return new


def main() -> int:
    if not SOURCE.exists():
        SOURCE.parent.mkdir(parents=True, exist_ok=True)
        if not EXAMPLE.exists():
            print(f"local-overrides: missing both {SOURCE} and {EXAMPLE}", file=sys.stderr)
            return 1
        shutil.copy(EXAMPLE, SOURCE)
        print(
            f"local-overrides: created {SOURCE} from {EXAMPLE}.\n"
            "  Fill in real values, then re-run `make local-overrides` (or `make setup`).",
            file=sys.stderr,
        )
        return 0

    with SOURCE.open("rb") as f:
        src = tomllib.load(f)

    renders = {
        "claude": render_claude(head_base(TARGETS["claude"]), src.get("claude", {}) or {}),
        "codex": render_codex(head_base(TARGETS["codex"]), src.get("codex", {}) or {}),
        "git": render_git(head_base(TARGETS["git"]), src.get("git", {}) or {}),
        "zprofile": render_zprofile(head_base(TARGETS["zprofile"]), src.get("go", {}) or {}),
        "zshrc": render_aliases(head_base(TARGETS["zshrc"]), src.get("aliases", {}) or {}),
    }
    for key, content in renders.items():
        TARGETS[key].write_text(content)

    paths = ", ".join(str(TARGETS[k].relative_to(REPO)) for k in renders)
    print(f"local-overrides: applied to {paths}")
    print("  These files are intentionally dirty in the working tree.")
    print("  Do not commit the overrides; re-run 'make local-overrides' after editing .local/source.toml.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
