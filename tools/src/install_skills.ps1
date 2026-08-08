<# 
.SYNOPSIS
    DMLab CEH - install_skills.ps1
    Install skills dari skills/ ke agent. DEFAULT = LOKAL PROJECT (.agents/),
    tidak pernah global kecuali eksplisit -Global. Orang yang clone project ini
    menjalankan ini agar skills terpasang di .agents project-nya sendiri.

.DESCRIPTION
    Agent-agnostic: mendukung opencode, Claude Code, Cursor, Codex, dan dir kustom.
    Format SKILL.md (YAML frontmatter name + description) didukung semua agent.

.EXAMPLE
    .\tools\src\install_skills.ps1                     # install ke .agents/ lokal project
    .\tools\src\install_skills.ps1 -Global             # (opsional) ke dir agent global
    .\tools\src\install_skills.ps1 -Agent opencode     # paksa agent tertentu (global mode)
    .\tools\src\install_skills.ps1 -List               # daftar target yang dikenali
    .\tools\src\install_skills.ps1 -Dir ~/.agents      # target dir kustom
    .\tools\src\install_skills.ps1 -Only offensive-sqli,offensive-xss
    .\tools\src\install_skills.ps1 -DryRun             # preview tanpa install
#>

[CmdletBinding()]
param(
    [switch]$Global,
    [string]$Agent,
    [string]$Dir,
    [string[]]$Only,
    [switch]$List,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Resolve-Path "$ScriptDir\..\.."
$SkillsDir = Join-Path $ProjectRoot "skills"
$LocalTarget = Join-Path $ProjectRoot ".agents\skills"

function Detect-GlobalDirs {
    $dirs = @()
    if ($env:APPDATA) { $dirs += Join-Path $env:APPDATA "opencode\skills" }
    if ($env:XDG_CONFIG_HOME) { $dirs += Join-Path $env:XDG_CONFIG_HOME "opencode\skills" }
    $homeDir = if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($env:HOME) { $env:HOME } else { "" }
    if ($homeDir) {
        @(
            "$homeDir\.config\opencode\skills"
            "$homeDir\.claude\skills"
            "$homeDir\.agents\skills"
            "$homeDir\.codex\skills"
        ) | Where-Object { Test-Path $_ } | ForEach-Object { $dirs += $_ }
    }
    return $dirs
}

function List-Targets {
    Write-Host "Target skill (mode default = lokal project):"
    Write-Host "  - $LocalTarget  (LOKAL project, .agents/)"
    $g = Detect-GlobalDirs
    Write-Host "Dir global (hanya dengan -Global):"
    if (-not $g) { Write-Host "  (tidak ada agent global terdeteksi)" }
    else { $g | ForEach-Object { Write-Host "  - $_" } }
}

function Install-To {
    param([string]$Dest, [string[]]$Selected)
    if (-not (Test-Path $Dest)) {
        New-Item -ItemType Directory -Path $Dest -Force | Out-Null
        Write-Host "  [create] $Dest"
    }

    $srcList = @()
    if ($Selected.Count -gt 0) {
        foreach ($s in $Selected) {
            $skillPath = Join-Path $SkillsDir $s
            if (Test-Path $skillPath -PathType Container) {
                $srcList += $s
            } else {
                Write-Host "  [skip] skill '$s' tidak ada"
            }
        }
    } else {
        $srcList = Get-ChildItem $SkillsDir -Directory | Select-Object -ExpandProperty Name
    }

    $n = 0
    foreach ($s in $srcList) {
        Copy-Item (Join-Path $SkillsDir $s) $Dest -Recurse -Force
        $n++
    }
    Write-Host "  [ok] $n skill -> $Dest"
}

Write-Host "=== DMLab CEH : install skills ==="
Write-Host "Sumber : $SkillsDir"

# Target kustom eksplisit menang
if ($Dir) {
    $expandedDir = $Dir.Replace("~", $HOME)
    if ($DryRun) {
        $count = if ($Only -and $Only.Count -gt 0) { $Only.Count } else { "semua" }
        Write-Host "  [dry-run] akan install $count skill -> $expandedDir"
    } else {
        Install-To $expandedDir $Only
    }
    Write-Host "Selesai."
    exit 0
}

if ($List) {
    List-Targets
    exit 0
}

# Mode default: LOKAL project
if (-not $Global) {
    if ($DryRun) {
        $count = if ($Only -and $Only.Count -gt 0) { $Only.Count } else { "semua" }
        Write-Host "  [dry-run] akan install $count skill -> $LocalTarget (lokal project)"
    } else {
        Install-To $LocalTarget $Only
    }
    Write-Host "Selesai. Skills terpasang di .agents project ini (tidak menyentuh global)."
    exit 0
}

# Mode global (eksplisit -Global)
$TARGETS = Detect-GlobalDirs
if ($Agent) {
    $TARGETS = $TARGETS | Where-Object { $_ -like "*$Agent*" }
}

if (-not $TARGETS) {
    Write-Host "Tidak ada target agent global. Pakai -Dir <path> untuk target kustom."
    exit 1
}

foreach ($t in $TARGETS) {
    if ($DryRun) {
        $count = if ($Only -and $Only.Count -gt 0) { $Only.Count } else { "semua" }
        Write-Host "  [dry-run] akan install $count skill -> $t (global)"
    } else {
        Install-To $t $Only
    }
}
Write-Host "Selesai. Skills terpasang global."