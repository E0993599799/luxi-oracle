---
pattern: On this Windows box, the Bash tool silently exits 1 with no output on Windows-style paths with spaces — switch to the PowerShell tool for filesystem/git exploration instead of retrying Bash.
date: 2026-08-19
source: "rrr: luxi-oracle"
concepts: [windows, bash-tool, powershell, tooling]
---

# Bash tool fails silently on Windows paths — use PowerShell

## What happened

Running `cd "D:\01 Main Work\...\luxi-oracle" && ls -la && cat package.json` via the Bash tool
returned exit code 1 with **zero stdout/stderr** — no error message to diagnose. Same for a later
`git log --oneline -20 && git remote -v` call. Switching the identical intent to the PowerShell
tool (`Get-ChildItem`, `git log`, `git remote -v`) worked immediately, every time.

Also hit: PowerShell's `Get-Date` does not accept bash `date` format strings
(`date "+%H:%M %Z (%A %d %B %Y)"` from the /rrr skill template) — it errors with
"Cannot bind parameter 'Date'". Use `Get-Date -Format "HH:mm (dddd dd MMMM yyyy)"` instead.

## Why

This machine's Bash tool is Git Bash, which doesn't reliably resolve Windows-style absolute paths
with spaces and drive letters the way native PowerShell does — it appears to fail during path
resolution before the compound `&&` chain even runs, with no error surfaced to the caller.

## How to apply

On this environment: default to the PowerShell tool for any command touching a Windows absolute
path (especially ones with spaces), git commands, or date formatting. Reserve the Bash tool for
POSIX-only scripts where the working directory is already POSIX-friendly. If a Bash call returns
exit 1 with no output at all (not even a partial error), don't retry Bash — pivot to PowerShell
immediately rather than spending a second round-trip guessing at the bash syntax.
