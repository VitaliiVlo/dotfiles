# Backup plan

Personal data protection plan. Three-vendor base: Apple (primary), Google (warm spare for selected categories), local drives, one SSD and one HDD (offsite via monthly rotation). 1Password decouples passwords from Apple ID.

Scope: macOS + iPhone + Apple Watch user, Gmail for personal email via Apple Mail, Time Machine to external SSD and HDD. No cloud backup service (Backblaze/Arq), no custom email domain.

## Threat model

Risks the plan covers, ranked by impact:

1. **Apple ID lockout.** Loses iCloud copies of Contacts/Calendar/Notes/Reminders/Photos/iPhone Backup (iMessage history stays in the local encrypted iPhone backup, since Messages in iCloud is kept off). Passwords protected by being in 1Password instead of Keychain.
2. **Google account ban.** Loses Gmail address and Google Drive copies. Mail history preserved by Apple Mail local cache; address change handled by switching to pre-positioned `@icloud.com` fallback.
3. **Single-site disaster** (fire, burglary, flood). Destroys Mac plus the home drive in one event. Monthly-rotated offsite drive survives.
4. **Hardware failure** (Mac, iPhone, a backup drive individually). Routine recovery from the other copies.
5. **Account credential compromise.** Mitigated by Apple two-factor authentication via trusted devices (Mac + iPhone + Watch), TOTP codes for Google and all other services stored inside 1Password, and 1Password Secret Key plus master password as the root credential.

Risks NOT covered:

- Joint Apple + Google ban in same event. Fallback = local-only data on rotating drives. Recoverable but full rebuild.
- Missed monthly drive swap. That month is single-site until next swap. Calendar reminder is mandatory.
- Targeted state-actor attack. Out of scope.

## Cloud storage tiers (already in place)

Two paid cloud subscriptions are already active. The plan assumes both stay current.

- **iCloud+ 200GB**. Hosts: iCloud Mail (`@icloud.com` address), iCloud Photos copy, iCloud Drive, Contacts / Calendar / Notes / Reminders sync, iPhone iCloud Backup, Hide My Email aliases, Private Relay. Resize up if Photos library plus iPhone backups approach the cap; resize down only if a quarterly check shows persistent free capacity.
- **Google AI Plus 400GB**. Hosts: Gmail mailbox storage, Google Drive for quarterly Takeout archives plus small exports (Notes Markdown dumps, vCard / `.ics` archives, 1Password Emergency Kit encrypted PDF), Google Photos if used as light secondary photo copy. Includes Google AI Plus features (Gemini + Workspace integrations). If the bundle ends, warm spare migrates to Google One Basic 100GB (mailbox + Takeout typically fit) or a higher AI tier (if Photos secondary copy grows).

Both tiers are vendor-locked: iCloud+ ends with the Apple ID, Google One ends with the Google account. Same accounts the plan is hardening, not independent. Treat them as the primary slot for each vendor, not as cross-vendor backup.

## Data inventory

| Data | Primary | Secondary | Offsite |
|---|---|---|---|
| Contacts | iCloud | Google Contacts (CardDAV sync) | TM on SSD and HDD |
| Calendar | iCloud | Google Calendar (CalDAV sync) | TM on SSD and HDD |
| Notes | Apple Notes (iCloud) | Quarterly Markdown export | TM on SSD and HDD |
| Reminders | Apple Reminders (iCloud) | Quarterly export | TM on SSD and HDD |
| Passwords | 1Password | Emergency Kit printed (home safe) | Emergency Kit printed (offsite copy) |
| Photos originals | Mac (Download Originals) | iCloud Photos | TM on SSD and HDD |
| Email | Gmail | Apple Mail local cache + quarterly Takeout | TM + Drive |
| Mac files | Mac internal SSD | TM on SSD (home) | TM on HDD (offsite, monthly rotation) |
| Dotfiles | Mac | GitHub | TM on SSD and HDD |
| `.local/source.toml` | Mac | 1Password attachment | TM on SSD and HDD |
| iPhone | iCloud Backup | Monthly encrypted local backup to Mac | TM on SSD and HDD |
| Apple Watch | Paired iPhone backup | (covered via iPhone) | (covered via iPhone) |

## One-time setup

### Apple ID hardening

1. System Settings → Apple Account → Sign-In & Security → Recovery Contacts. Add 2 trusted family members on iCloud.
2. Same screen → Recovery Key → enable. Print 2 copies. Store one in home safe, one offsite (parents / bank box).
3. Recovery email: set to `@icloud.com` (activated below), not Gmail.

Apple's built-in two-factor authentication via trusted devices (Mac + iPhone + Watch) is the everyday second factor. No hardware key registered.

Note: enabling Recovery Key disables Apple-support-driven account recovery. Recovery Contacts + Recovery Key together is the correct combination.

### iCloud Mail fallback

1. System Settings → Apple Account → iCloud → iCloud Mail → On.
2. Pick address (e.g. `firstname.lastname@icloud.com`).
3. Send test mail to/from the address to confirm working.
4. Use this address as recovery email on: Apple ID, Google, 1Password, GitHub, bank, brokerage, primary work tools.

### Google account hardening

1. Enable 2-Step Verification at myaccount.google.com → Security. Add Authenticator as the second factor. When Google displays the QR code, in 1Password create or open the Google Login item, edit the one-time-password field, and either scan the QR with the 1Password mobile camera or paste the manual setup key. 1Password now generates the 6-digit codes. Do **not** install a separate authenticator app.
2. Generate backup codes, print, store with Recovery Key printouts.
3. Recovery email: `@icloud.com` (not the Gmail address being recovered).
4. Recovery phone: current mobile number.
5. Avoid sign-ins from VPN with unfamiliar geo. Avoid uploading content likely to trip CSAM ML (kid medical photos, encrypted archives flagged as obfuscation).

### 1Password setup

1. Sign up for 1Password Individual.
2. Strong master password (long passphrase, store in 1Password Emergency Kit only).
3. Do not enable separate TOTP for the 1Password account itself. The Secret Key plus master password are the design-level credentials, and storing 1Password's own TOTP inside 1Password creates a chicken-and-egg lockout on new devices. The Emergency Kit printout is the recovery path for new-device sign-in.
4. Download Emergency Kit PDF (Settings → Account → Save Emergency Kit). Print 2 copies. Same storage locations as Apple Recovery Key.
5. Import from Apple Passwords: 1Password 8 → File → Import → Apple Passwords (macOS Sequoia+).
6. Verify 20 random logins work via 1Password autofill.
7. System Settings → Apple Account → iCloud → Passwords → Off. (Disables iCloud Keychain entirely; passwords now single-source in 1Password.)
8. System Settings → General → AutoFill & Passwords → set 1Password as autofill provider; turn off Apple Passwords autofill.
9. Attach `.local/source.toml` as encrypted file attachment to a 1Password item named `dotfiles overrides`.

### Apple Mail local cache for Gmail

Goal: preserve full Gmail history locally so it survives a Google ban.

1. Mail → Settings → Accounts → (Gmail account) → Mailbox Behaviours: store Sent, Drafts, Junk, Trash on server (default).
2. Same panel → Advanced → IMAP Path Prefix: empty. Keep "Download Attachments: All".
3. In Mail sidebar, expand the Gmail account. For "All Mail" folder: right-click → Use This Mailbox As → Archive (forces sync of full history).
4. Let Mail run for 24-48 hours. Verify `~/Library/Mail/V*/<account-uuid>/` grows to approximate Gmail size.
5. Time Machine captures `~/Library/Mail/` by default, so the cache lands on SSD and HDD.

### Photos config

1. System Settings → Apple Account → iCloud → Photos.
2. Set "Sync this Mac" → On.
3. Storage mode: **Download Originals to this Mac** (not Optimize Mac Storage). This guarantees full originals live on disk so Time Machine and the offsite drive have real files, not thumbnails.
4. Verify: Finder → `~/Pictures/Photos Library.photoslibrary` → Get Info → size matches expected total.

### Google as secondary Contacts/Calendar sync

Goal: independent mirror of Contacts and Calendar outside Apple ID.

On Mac:

1. System Settings → Internet Accounts → Add Account → Google.
2. Enable Contacts + Calendars toggles.

On iPhone:

1. Settings → Apps → Contacts → Default Account → iCloud (keep Apple as primary).
2. Settings → Apps → Calendar → Default Calendar → iCloud (same).
3. Settings → Apps → Mail → Mail Accounts → Add Google → enable Contacts + Calendars.

Sync direction: new entries default to iCloud (primary), Google is a read/write mirror. Existing iCloud entries copy to Google via account sync.

### Local drive setup

Hardware: 1x 1TB external SSD (`tm-home`) + 1x 2TB external HDD (`tm-offsite`), USB-C 3.2 Gen 2 or Thunderbolt. Mixing SSD and HDD gives two different failure profiles, so a flaw that kills one media type does not take both copies. Size each drive to roughly 1.5-2x the Mac's used space; Time Machine needs headroom for version history and silently drops the oldest snapshots once a drive fills.

1. For each drive: Disk Utility → Erase → Format: APFS (Encrypted), name `tm-home` (SSD) and `tm-offsite` (HDD). Set strong password; store in 1Password and on the printed Emergency Kit, so the drive opens even during a 1Password outage (see the breakglass export under Quarterly).
2. System Settings → General → Time Machine → Add Backup Disk → select both.
3. SSD (`tm-home`): stays at home, plugged into Mac (or via dock).
4. HDD (`tm-offsite`): initial seed at home, then moved offsite (parents / work / bank box).

### iPhone backup

1. Settings → Apple Account → iCloud → iCloud Backup → On (default).
2. Monthly: connect iPhone to Mac via cable, Finder → iPhone in sidebar → Backups → "Back up all data on iPhone to this Mac" → Encrypt local backup (set password, store in 1Password) → Back Up Now.
3. Time Machine captures `~/Library/Application Support/MobileSync/Backup/` so the encrypted iPhone backup lands on SSD and HDD.

Note: keep Messages in iCloud OFF (Settings → Apple Account → iCloud → Show All → Messages) so the encrypted local backup holds full iMessage history. With it ON, messages live in iCloud under the Apple ID and the local backup keeps little, so an Apple ID loss takes the history with it.

## Recurring rituals

Set calendar reminders for each.

### Monthly (first weekend)

- [ ] Swap SSD and HDD: bring the offsite drive home, plug in, let Time Machine catch up. Take the home drive offsite to replace it.
- [ ] Run an encrypted local iPhone backup via Finder.
- [ ] Verify Time Machine backup completed successfully on the newly-swapped-in drive (System Settings → General → Time Machine → check timestamp).

### Quarterly

- [ ] Gmail Takeout: takeout.google.com → select Mail (`.mbox`) + Contacts + Calendar + Drive → save `.zip` to `~/Backups/Takeout/YYYY-Qn/`.
- [ ] Notes export: use [Obsidian Importer](https://github.com/obsidianmd/obsidian-importer) (first-party Obsidian plugin → Apple Notes format) → Markdown dump to a quarterly vault at `~/Backups/Notes/YYYY-Qn/`.
- [ ] Reminders export: Reminders app → File → Export → save `.ics` to `~/Backups/Reminders/YYYY-Qn/`.
- [ ] Contacts vCard export: Contacts → File → Export → Contacts Archive.
- [ ] Calendar `.ics` export: Calendar → File → Export → Calendar Archive.
- [ ] Restore test: pull 1 random file from Time Machine (home drive) and 1 file from the offsite drive after swap. Open and verify content.
- [ ] Verify 1Password Emergency Kit Secret Key matches printed copy (read the printout, paste into a verify-only check).
- [ ] 1Password breakglass export: 1Password → File → Export → save the `.1pux` export to `~/Backups/1Password/YYYY-Qn/` so it rides Time Machine to both drives. Vendor-independent offline copy of the secrets themselves, for a 1Password service outage (the Emergency Kit only restores account access, which is useless if the service is down). The export is plaintext inside the APFS-encrypted drive, so the drive password is its only guard; that password is on the Emergency Kit printout per Local drive setup. Delete the prior quarter's export after writing the new one.
- [ ] Confirm Apple Recovery Contacts are reachable (text them) and Recovery Key printouts are findable.

### Yearly (first weekend of January)

- [ ] Review registered 2FA services on Apple ID, Google, 1Password, GitHub, bank, brokerage. Open each TOTP entry in 1Password and confirm it generates a code accepted by the service. Remove stale services.
- [ ] Confirm Recovery Contact phone numbers / addresses still current.
- [ ] Rotate critical-account passwords: bank, brokerage, 1Password master, Apple ID.

## Recovery playbook

### iPhone stolen or broken

1. iCloud.com → Find Devices → mark device as lost; if confirmed gone, erase.
2. On new iPhone: setup wizard → Restore from iCloud Backup (or local encrypted backup on Mac via Finder).
3. Apple Watch re-pairs from iPhone during setup.
4. Re-install 1Password app, sign in with master password plus Secret Key from Emergency Kit. TOTP codes for Google and every other service generate automatically from the synced 1Password vault.

### Mac broken

1. Replacement Mac → boot → sign in to Apple ID.
2. Migration Assistant → From a Mac, Time Machine backup, or Startup Disk → select the home drive (SSD). If the home drive destroyed too, retrieve HDD from offsite location.
3. Install 1Password, sign in using master password + Secret Key from Emergency Kit.
4. Re-add Time Machine destinations.
5. Verify Apple Mail re-builds local message cache from Gmail.

### Single drive failure

1. Replace failed drive with new media of the same type (SSD or HDD).
2. Disk Utility → Erase → APFS Encrypted, same naming convention.
3. System Settings → Time Machine → Add new disk.
4. First fresh backup runs over next several hours. Until then, surviving drive is single point.

### Home destroyed (fire / burglary, Mac + home drive lost)

1. New hardware.
2. Retrieve the offsite drive from its location.
3. Migration Assistant from the offsite drive. Worst case ~1 month stale (since last swap).
4. Recent data delta = anything created since last swap. For synced data (Mail / Contacts / Calendar / Notes / iCloud Drive) iCloud has live copies. For local-only files modified in the last month: lost.

### Apple ID temporarily locked

1. Try Recovery Contacts flow (Apple ID account page → Forgot Apple ID).
2. If Contacts unreachable: use Recovery Key (printed copy).
3. If both fail: Apple Support call. Provide device serial, payment method, receipts. Expect 1-2 weeks.
4. While locked: Mac plus the local drives hold local copies. iPhone falls back to no-iCloud mode but stays functional. 1Password unaffected.

### Apple ID permanently lost

1. New Apple ID. Sign in on devices. iCloud Mail address is gone, so switch primary email back to Gmail.
2. Critical accounts: update recovery email via each service's support flow (bank, brokerage, GitHub, etc.).
3. Contacts and Calendar: restore from Google sync copy (still live in your Google account).
4. Notes and Reminders: restore from quarterly Markdown / `.ics` exports.
5. Photos: restore from the most recent rotated drive (each drive's Time Machine carries the full Photos Library).
6. Passwords: 1Password unaffected (separate vendor).
7. iMessage history: restore from the monthly encrypted local iPhone backup (Finder → restore), which holds the full thread history when Messages in iCloud is kept OFF per iPhone backup. New messages bind to the new Apple ID / number going forward.

### Gmail address banned

1. Read Apple Mail local cache (`~/Library/Mail/`) to preserve historical context.
2. Within 24-48 hours: switch primary email on critical accounts to `@icloud.com`: 1Password, Apple, bank, brokerage, GitHub, primary work tools.
3. Over next 4 weeks: long tail of service logins. Triage by importance.
4. For historical Gmail content: use most recent Takeout `.mbox` (loadable in Apple Mail via File → Import Mailboxes).
5. New mail going forward: Apple Mail on `@icloud.com`. Risk note: this consolidates more into Apple, so Apple ID hardening becomes more load-bearing.

### 1Password lockout (forgot master password OR Secret Key lost)

1. Retrieve Emergency Kit printout from home safe or offsite copy.
2. Sign in on a new device using Secret Key + master password slot from Emergency Kit.
3. If both printed copies lost AND device cache empty: account is unrecoverable by design. Reset, rebuild from browser-saved logins and per-service password reset via email.

## Trust boundary notes

- Cloudflare custom domain and cloud backup providers (Backblaze, Fastmail, Proton) intentionally excluded. Reduces vendor surface, accepts the tradeoff of (a) manual offsite discipline via drive rotation and (b) address-change exposure if Gmail bans the account.
- `@icloud.com` fallback consolidates more into Apple after a Gmail ban. Recovery Contacts + Recovery Key + Apple's trusted-device 2FA (Mac + iPhone + Watch) are the load-bearing protections as a result.
- Passwords are the one paid third-party tool (1Password) because Apple Passwords inside Apple ID creates a cascade-failure risk under Apple lockout. Independent vendor breaks the chain.
- Offsite drive rotation only protects if done. The monthly calendar reminder is the linchpin of the entire plan.
- The Mac-files chain meets 3-2-1: three copies (Mac, home drive, offsite drive), two media types (SSD + HDD), one offsite. The offsite drive is also air-gapped most of the month (physically disconnected), so ransomware or accidental mass-deletion on the Mac cannot reach it between swaps.
- Apple **Advanced Data Protection** (ADP) is off by default; opting in extends end-to-end encryption to iCloud Backup, Photos, Notes, Reminders, Safari Bookmarks, and Wallet passes (categories Apple otherwise holds keys for). With ADP on, Apple cannot recover those categories under any support flow, so Recovery Contacts + Recovery Key become the only path. The plan already configures both, so it works in either state; the trade-off is privacy posture vs Apple-Support-assisted recovery. Decide deliberately before flipping the switch in System Settings → Apple Account → iCloud → Advanced Data Protection.
