<#
PowerShell installer for copilot-agent templates (Windows / CLI).
Usage:
  pwsh -NoProfile -ExecutionPolicy Bypass -File ./install.ps1
  or remote:
  pwsh -NoProfile -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/firmantr3/copilot-agent/main/install.ps1' -UseBasicParsing | iex"
#>

$ErrorActionPreference = 'Stop'

$repoRawBase = 'https://raw.githubusercontent.com/firmantr3/copilot-agent/main'

# Avoid `HOME` name collision with PS read-only automatic variable in some shells
$profileHome = [Environment]::GetFolderPath('UserProfile')
$copilotDir = Join-Path $profileHome '.copilot\agents'

# Determine whether running on Windows in a cross-version way
if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)) {
  $isWindowsPlatform = $true
} elseif ($PSVersionTable -and $PSVersionTable.Platform -eq 'Win32NT') {
  $isWindowsPlatform = $true
} elseif ($env:OS -eq 'Windows_NT') {
  $isWindowsPlatform = $true
} else {
  $isWindowsPlatform = $false
}

if ($isWindowsPlatform) {
  $appData = [Environment]::GetFolderPath('ApplicationData')
  if ([string]::IsNullOrWhiteSpace($appData)) {
    $appData = Join-Path $profileHome 'AppData\Roaming'
  }
  $promptsDir = Join-Path $appData 'Code\User\prompts'
} else {
  $promptsDir = Join-Path $profileHome '.config/Code/User/prompts'
}

New-Item -ItemType Directory -Force -Path $copilotDir | Out-Null
New-Item -ItemType Directory -Force -Path $promptsDir | Out-Null

$currentDir = Get-Location
$localAgentsDir = Join-Path $currentDir.Path 'agents'
$localPromptsDir = Join-Path $currentDir.Path 'prompts'

$agentFiles = @('plan-kiro.agent.md', 'plan-plus.agent.md')
$promptFiles = @('generate-steering.prompt.md', 'update-steering.prompt.md')

function Download-File($url, $dest) {
  if (Get-Command Invoke-WebRequest -ErrorAction SilentlyContinue) {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
  } else {
    throw 'Invoke-WebRequest not available'
  }
}

if ((Test-Path $localAgentsDir -PathType Container) -and (Test-Path $localPromptsDir -PathType Container)) {
  Write-Host "Using local repository files from $currentDir"
  Get-ChildItem -Path $localAgentsDir -Filter '*.md' | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $copilotDir -Force
    Write-Host "Copied $($_.Name) -> $copilotDir"
  }
  foreach ($f in $promptFiles) {
    Copy-Item -Path (Join-Path $localPromptsDir $f) -Destination (Join-Path $promptsDir $f) -Force
    Write-Host "Copied $f -> $promptsDir"
  }
} else {
  Write-Host "Local repo files not found; downloading from GitHub"
  foreach ($f in $agentFiles) {
    $url = "$repoRawBase/agents/$f"
    $dest = Join-Path $copilotDir $f
    Download-File -url $url -dest $dest
    Write-Host "Downloaded $f -> $dest"
  }
  foreach ($f in $promptFiles) {
    $url = "$repoRawBase/prompts/$f"
    $dest = Join-Path $promptsDir $f
    Download-File -url $url -dest $dest
    Write-Host "Downloaded $f -> $dest"
  }
}

Write-Host "Installation completed."
Write-Host "Agents path: $copilotDir"
Write-Host "Prompts path: $promptsDir"
