$ErrorActionPreference = "Stop"

$Target = "latest"
if ($args.Count -ge 1) {
    $Target = $args[0]
}

function Find-Tool {
    param([Parameter(Mandatory = $true)][string]$Name)
    $Cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($Cmd) { return $Cmd.Source }
    return $null
}

$Root = Resolve-Path "$PSScriptRoot/.."

$Python = Find-Tool "python"
if (-not $Python) { $Python = Find-Tool "py" }
if (-not $Python) {
    Write-Host "missing: python"
    Write-Host "needed : current kernel switch"
    exit 1
}

& $Python (Join-Path $Root "tools/set_current.py") $Target --root $Root
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
