# Luxi Oracle — SessionEnd hook: push a short session summary to พี่เอก via LINE.
#
# Uses the existing, working control_fleet LINE bridge (scripts/line-push.mjs) —
# this script never edits anything inside control_fleet, only invokes it.
#
# Reads today's most recent retrospective's "## Session Summary" section if one
# was written this session; falls back to a generic message otherwise.

$ErrorActionPreference = 'SilentlyContinue'

$luxiRoot = "D:\01 Main Work\Boots\Agentic AI\mission-control\royal-master-oracle\luxi-oracle"
$controlFleet = "D:\01 Main Work\Boots\Agentic AI\mission-control\control_fleet"

$yearMonth = Get-Date -Format "yyyy-MM"
$day = Get-Date -Format "dd"
$retroDir = Join-Path $luxiRoot "ψ\memory\retrospectives\$yearMonth\$day"

$summary = $null
if (Test-Path $retroDir) {
    $latest = Get-ChildItem $retroDir -Filter "*.md" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) {
        $content = Get-Content $latest.FullName -Raw
        if ($content -match '(?ms)^## Session Summary\s*\r?\n\r?\n(.+?)(\r?\n\r?\n##|\r?\n---)') {
            $summary = $matches[1].Trim()
        }
    }
}

if (-not $summary) {
    $summary = "Session ended — no retrospective was written this session."
}

if ($summary.Length -gt 1200) {
    $summary = $summary.Substring(0, 1200) + "..."
}

$text = "[agent: luxi-oracle] Session ended.`n`n$summary"

Push-Location $controlFleet
try {
    node scripts/line-push.mjs --text $text
} finally {
    Pop-Location
}
