<#
PowerShell installer for copilot-agent templates (Windows / CLI).
Usage:
  pwsh -NoProfile -ExecutionPolicy Bypass -File ./install.ps1
  or remote:
  pwsh -NoProfile -ExecutionPolicy Bypass -Command "iwr 'https://cdn.jsdelivr.net/gh/firmantr3/copilot-agent@main/install.ps1' -UseBasicParsing | iex"
#>

$ErrorActionPreference = 'Stop'

$repoRawBase = 'https://cdn.jsdelivr.net/gh/firmantr3/copilot-agent@main'

$profileHome = [Environment]::GetFolderPath('UserProfile')
$copilotHome = Join-Path $profileHome '.copilot'
$copilotDir = Join-Path $copilotHome 'agents'
$firmantr3Dir = Join-Path $copilotHome 'firmantr3'

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
New-Item -ItemType Directory -Force -Path $firmantr3Dir | Out-Null
New-Item -ItemType Directory -Force -Path $promptsDir | Out-Null

$scriptDir = $PSScriptRoot
$localAgentsDir = if ($scriptDir) { Join-Path $scriptDir 'agents' } else { '' }
$localPromptsDir = if ($scriptDir) { Join-Path $scriptDir 'prompts' } else { '' }
$localSharedDir = if ($scriptDir) { Join-Path $scriptDir 'shared' } else { '' }

# Fallback lists for remote install (when directory listing isn't available)
$agentFiles = @('plan-kiro.agent.md', 'plan-plus.agent.md', 'execute-kiro.agent.md')
$sharedFiles = @('explore-checklist.md')
$promptFiles = @('generate-steering.prompt.md', 'update-steering.prompt.md')

function Confirm-Overwrite {
  param([string]$Dest)
  if (Test-Path $Dest) {
    # Non-interactive mode — always overwrite
    if (-not [Environment]::UserInteractive) {
      Write-Host "[INFO] Overwriting $(Split-Path $Dest -Leaf) (non-interactive mode)"
      return $true
    }
    $answer = Read-Host "[PROMPT] File '$(Split-Path $Dest -Leaf)' already exists. Overwrite? [y/N]"
    if ($answer -match '^[yY]') {
      return $true
    } else {
      Write-Host "[WARN] Skipped $(Split-Path $Dest -Leaf)"
      return $false
    }
  }
  return $true
}

function Download-File($url, $dest) {
  if (Get-Command Invoke-WebRequest -ErrorAction SilentlyContinue) {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
  } else {
    throw 'Invoke-WebRequest not available'
  }
}

if ($scriptDir -and (Test-Path $localAgentsDir -PathType Container) -and (Test-Path $localPromptsDir -PathType Container)) {
  Write-Host "Using local repository files from $scriptDir"

  # Copy all .md files from agents/
  Get-ChildItem -Path $localAgentsDir -Filter '*.md' | ForEach-Object {
    $dest = Join-Path $copilotDir $_.Name
    if (Confirm-Overwrite -Dest $dest) {
      Copy-Item -Path $_.FullName -Destination $dest -Force
      Write-Host "Copied $($_.Name) -> $copilotDir"
    }
  }

  # Copy all .md files from prompts/
  Get-ChildItem -Path $localPromptsDir -Filter '*.md' | ForEach-Object {
    $dest = Join-Path $promptsDir $_.Name
    if (Confirm-Overwrite -Dest $dest) {
      Copy-Item -Path $_.FullName -Destination $dest -Force
      Write-Host "Copied $($_.Name) -> $promptsDir"
    }
  }
  # Copy all .md files from shared/
  if (Test-Path $localSharedDir -PathType Container) {
    Get-ChildItem -Path $localSharedDir -Filter '*.md' | ForEach-Object {
      $dest = Join-Path $firmantr3Dir $_.Name
      if (Confirm-Overwrite -Dest $dest) {
        Copy-Item -Path $_.FullName -Destination $dest -Force
        Write-Host "Copied $($_.Name) -> $firmantr3Dir"
      }
    }
  }
} else {
  Write-Host "Local repo files not found; downloading from GitHub"
  foreach ($f in $agentFiles) {
    $url = "$repoRawBase/agents/$f"
    $dest = Join-Path $copilotDir $f
    if (Confirm-Overwrite -Dest $dest) {
      Download-File -url $url -dest $dest
      Write-Host "Downloaded $f -> $dest"
    }
  }
  foreach ($f in $promptFiles) {
    $url = "$repoRawBase/prompts/$f"
    $dest = Join-Path $promptsDir $f
    if (Confirm-Overwrite -Dest $dest) {
      Download-File -url $url -dest $dest
      Write-Host "Downloaded $f -> $dest"
    }
  }
  foreach ($f in $sharedFiles) {
    $url = "$repoRawBase/shared/$f"
    $dest = Join-Path $firmantr3Dir $f
    if (Confirm-Overwrite -Dest $dest) {
      Download-File -url $url -dest $dest
      Write-Host "Downloaded $f -> $dest"
    }
  }
}

Write-Host "Installation completed."
Write-Host "Agents path: $copilotDir"
Write-Host "Prompts path: $promptsDir"
Write-Host "Shared configs path: $firmantr3Dir"
