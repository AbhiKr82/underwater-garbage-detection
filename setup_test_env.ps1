# =============================================================================
# setup_test_env.ps1
# Creates a lightweight Python virtual environment for inference / testing.
# Usage (run once from the d:\Project folder):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\setup_test_env.ps1
# =============================================================================

$EnvName = "venv_test"
$EnvPath = Join-Path $PSScriptRoot $EnvName
$Req     = Join-Path $PSScriptRoot "requirements_test.txt"

Write-Host ""
Write-Host "============================================================"
Write-Host "  YOLOv10 Underwater Garbage - Test Environment Setup"
Write-Host "============================================================"
Write-Host ""

# Check Python availability
$PythonExe = $null
foreach ($cmd in @("python", "python3")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python 3\.") {
            $PythonExe = $cmd
            Write-Host "  Python found : $ver  ($cmd)"
            break
        }
    } catch { }
}

if ($PythonExe -eq $null) {
    Write-Host "  ERROR: Python 3 not found in PATH." -ForegroundColor Red
    Write-Host "  Install Python 3.10-3.12 from https://python.org and re-run." -ForegroundColor Red
    exit 1
}

# Create virtual environment
if (Test-Path $EnvPath) {
    Write-Host ""
    Write-Host "  Environment '$EnvName' already exists at $EnvPath"
    Write-Host "  Delete it first if you want a clean reinstall:"
    Write-Host "    Remove-Item -Recurse -Force $EnvPath"
} else {
    Write-Host ""
    Write-Host "  Creating virtual environment at: $EnvPath ..."
    & $PythonExe -m venv $EnvPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERROR: venv creation failed." -ForegroundColor Red
        exit 1
    }
    Write-Host "  Virtual environment created." -ForegroundColor Green
}

# Activate and upgrade pip
$Activate = Join-Path $EnvPath "Scripts\Activate.ps1"
& $Activate

Write-Host ""
Write-Host "  Upgrading pip ..."
python -m pip install --upgrade pip -q

# Install inference requirements
if (Test-Path $Req) {
    Write-Host ""
    Write-Host "  Installing packages from requirements_test.txt ..."
    Write-Host "  (This may take a few minutes on first run)"
    Write-Host ""
    pip install -r $Req
} else {
    Write-Host "  WARNING: requirements_test.txt not found at $Req" -ForegroundColor Yellow
    Write-Host "  Installing core packages directly ..."
    pip install torch torchvision "ultralytics>=8.2.0" opencv-python matplotlib Pillow numpy pyyaml pandas
}

# Register Jupyter kernel
Write-Host ""
Write-Host "  Registering Jupyter kernel as 'Python (venv_test)' ..."
pip install ipykernel -q
python -m ipykernel install --user --name venv_test --display-name "Python (venv_test)"

# Done
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:"
Write-Host "  1. Reload VS Code (Ctrl+Shift+P > 'Reload Window')"
Write-Host "  2. Open yolov10_underwater_garbage.ipynb"
Write-Host "  3. Select kernel: 'Python (venv_test)'  (bottom-right of VS Code)"
Write-Host "  4. Run Section 0 -> Section 2 -> Section 11"
Write-Host "  5. Set TEST_IMAGE_PATH in Section 11 and run the cell"
Write-Host ""
Write-Host "  To activate manually in a terminal:"
Write-Host "    .\$EnvName\Scripts\Activate.ps1"
Write-Host ""
