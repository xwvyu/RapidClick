[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$venvPath = Join-Path $projectRoot ".build-venv"
$pythonPath = Join-Path $venvPath "Scripts\python.exe"
$pyInstallerPath = Join-Path $venvPath "Scripts\pyinstaller.exe"

if (-not (Test-Path -LiteralPath $pythonPath)) {
    py -3 -m venv $venvPath
}

& $pythonPath -m pip install --disable-pip-version-check -r (Join-Path $projectRoot "requirements-build.txt")
& $pyInstallerPath --noconfirm --clean --onefile --windowed --name RapidClick --collect-all customtkinter (Join-Path $projectRoot "main.py")

$exePath = Join-Path $projectRoot "dist\RapidClick.exe"
$hash = (Get-FileHash -LiteralPath $exePath -Algorithm SHA256).Hash
$checksumPath = Join-Path $projectRoot "dist\RapidClick.exe.sha256"
"$hash *RapidClick.exe" | Set-Content -LiteralPath $checksumPath -Encoding ASCII -NoNewline

Write-Host "Built: $exePath"
Write-Host "SHA-256: $hash"
