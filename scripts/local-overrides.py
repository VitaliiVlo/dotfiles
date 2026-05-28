#!/usr/bin/env python3
"""Render local overrides from .local/source.toml into tracked configs.

Each run reads the clean base for the four tracked files from `git show HEAD:<path>`
so overrides apply against a known starting point and never compound. The resulting
working-tree diff is intentional and must stay uncommitted.
"""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SOURCE = REPO / ".local/source.toml"
EXAMPLE = REPO / ".local.example.toml"

TARGETS = {
    "claude": REPO / ".config/claude/settings.json",
    "codex": REPO / ".config/codex/config.toml",
    "git": REPO / ".config/git/config",
    "zprofile": REPO / ".zprofile",
}


def head_base(path: Path) -> str:
    """Return the file's content at HEAD, or its current working copy if not yet committed."""
    rel = path.relative_to(REPO).as_posix()
    try:
        return subprocess.check_output(
            ["git", "-C", str(REPO), "show", f"HEAD:{rel}"],
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except subprocess.CalledProcessError:
        print(
            f"local-overrides: HEAD:{rel} missing; using working copy as base. "
            "Commit the new target path so HEAD-based renders stay clean.",
            file=sys.stderr,
        )
        return path.read_text()


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
    for pid in plugins:
        data["enabledPlugins"][pid] = True

    return json.dumps(data, indent=2) + "\n"


def render_codex(base: str, codex: dict) -> str:
    projects = list(dict.fromkeys(codex.get("trusted_projects", []) or []))
    if not projects:
        return base
    block = ["\n# Trusted projects (rendered from .local/source.toml)"]
    for p in projects:
        # json.dumps emits a valid TOML basic string (same escape rules).
        block.append(f"[projects.{json.dumps(p)}]\ntrust_level = \"trusted\"")
    return base.rstrip() + "\n" + "\n".join(block) + "\n"


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
    # Match `[user]` header through (but not including) the next section header.
    # Lambda replacement so backslash sequences in email/name are not interpreted as regex backrefs.
    return re.sub(r"^\[user\][^\[]*", lambda _: replacement, base, count=1, flags=re.M)


def render_zprofile(base: str, go: dict) -> str:
    private = go.get("private", "")
    if not private:
        return base
    # Lambda replacement so backslash sequences in `private` are not interpreted as regex backrefs.
    return re.sub(
        r'^export GOPRIVATE=".*?"\s*$',
        lambda _: f'export GOPRIVATE="{private}"',
        base,
        count=1,
        flags=re.M,
    )


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
