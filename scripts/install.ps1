# 9M2PJU HamClock - Automated Windows One-Click Installer
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Website: https://hamclock.hamradio.my

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Write-Header {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "      9M2PJU HamClock - Windows Installer           " -ForegroundColor Yellow
    Write-Host "   Space Weather, Propagation & Telemetry Dashboard   " -ForegroundColor Green
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host ""
}

Write-Header

# 1. Check for Docker Desktop
$dockerAvailable = $false
try {
    $dockerVersion = docker --version 2>$null
    if ($dockerVersion) {
        $dockerAvailable = $true
    }
} catch {}

# 2. Check for WSL (Windows Subsystem for Linux)
$wslAvailable = $false
try {
    $wslStatus = wsl --status 2>$null
    if ($LASTEXITCODE -eq 0) {
        $wslAvailable = $true
    }
} catch {}

Write-Host "🔍 Detecting Windows Environment..." -ForegroundColor White
if ($dockerAvailable) {
    Write-Host "  [✓] Docker Desktop detected" -ForegroundColor Green
} else {
    Write-Host "  [ ] Docker Desktop not detected" -ForegroundColor DarkGray
}

if ($wslAvailable) {
    Write-Host "  [✓] Windows Subsystem for Linux (WSL) detected" -ForegroundColor Green
} else {
    Write-Host "  [ ] WSL not installed" -ForegroundColor DarkGray
}
Write-Host ""

# Selection Menu
Write-Host "Please choose your preferred installation method:" -ForegroundColor Yellow
Write-Host "  [1] Docker Container (Recommended for Windows - Fast & Isolated)" -ForegroundColor Cyan
Write-Host "  [2] Native GUI via WSL2 / WSLg (Runs on desktop like a native app)" -ForegroundColor Cyan
Write-Host "  [3] Launch Live Web Mirror in Browser (http://localhost:8081)" -ForegroundColor Cyan
Write-Host "  [Q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter option [1-3, Q]"

switch ($choice) {
    "1" {
        if (-not $dockerAvailable) {
            Write-Host "❌ Docker Desktop is not running. Please start Docker Desktop or install it from https://docker.com" -ForegroundColor Red
            Exit 1
        }
        Write-Host "🚀 Pulling and starting 9M2PJU HamClock Docker container..." -ForegroundColor Green
        docker pull ghcr.io/9m2pju/9m2pju-hamclock-docker:latest
        docker rm -f hamclock 2>$null | Out-Null
        docker run -d `
            --name hamclock `
            --restart unless-stopped `
            -p 8080:8080 `
            -p 8081:8081 `
            -p 8082:8082 `
            -v "$env:USERPROFILE\.hamclock:/root/.hamclock" `
            ghcr.io/9m2pju/9m2pju-hamclock-docker:latest

        Write-Host ""
        Write-Host "✅ HamClock is running in the background!" -ForegroundColor Green
        Write-Host "🌐 Opening interactive dashboard in default browser..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        Start-Process "http://localhost:8081/live.html"
    }

    "2" {
        if (-not $wslAvailable) {
            Write-Host "❌ WSL is not installed. To install WSL, open PowerShell as Administrator and run: wsl --install" -ForegroundColor Red
            Exit 1
        }
        Write-Host "🚀 Installing and compiling HamClock inside WSL..." -ForegroundColor Green
        wsl -e bash -c "curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash"
        
        Write-Host ""
        Write-Host "✅ Installation completed in WSL." -ForegroundColor Green
        Write-Host "💡 To start HamClock anytime from PowerShell / Command Prompt, run:" -ForegroundColor Yellow
        Write-Host "   wsl -e ~/.local/bin/hamclock -r 1600x960" -ForegroundColor White
        
        $launch = Read-Host "Launch HamClock now? (Y/N)"
        if ($launch -eq "Y" -or $launch -eq "y") {
            wsl -e ~/.local/bin/hamclock -r 1600x960
        }
    }

    "3" {
        Write-Host "🌐 Opening http://localhost:8081/live.html..." -ForegroundColor Green
        Start-Process "http://localhost:8081/live.html"
    }

    Default {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
    }
}
