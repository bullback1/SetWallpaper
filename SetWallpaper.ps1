# This script sets the desktop wallpaper based on the current screen resolution.
# Usage:
# 1. Set the desired wallpaper image file paths.
# 2. Run this script in PowerShell.

# Define a class to use the Windows API for setting the wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Define constants
$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 1
$SPIF_SENDCHANGE = 2

# Function to get the current screen resolution
function Get-ScreenResolution {
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $width = $screen.Bounds.Width
    $height = $screen.Bounds.Height
    return "$width x $height"
}

# Set wallpaper image paths (users can modify these paths)
$wallpaperPath1 = "C:\yourfolder\untitled(1).png"
$wallpaperPath2 = "C:\yourfolder\untitled(2).png"

# Define resolution settings
$resolution1 = "2560 x 1080"
$resolution2 = "1920 x 1080"

# Function to set the wallpaper using the Windows API
function Set-Wallpaper {
    param (
        [string]$path
    )
    
    if (-Not (Test-Path $path)) {
        Write-Output "File does not exist: $path"
        return
    }

    $path = [System.IO.Path]::GetFullPath($path)
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $path, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
}

# Get the current screen resolution
try {
    $resolution = Get-ScreenResolution
    Write-Output "Current Resolution: $resolution"
    
    # Check the resolution and set the wallpaper accordingly
    if ($resolution -eq $resolution1) {
        Set-Wallpaper -path $wallpaperPath1
        Write-Output "Wallpaper set to: $wallpaperPath1"
    } elseif ($resolution -eq $resolution2) {
        Set-Wallpaper -path $wallpaperPath2
        Write-Output "Wallpaper set to: $wallpaperPath2"
    } else {
        Write-Output "No matching resolution found for the wallpapers."
    }
} catch {
    Write-Output "Error: $_"
}
