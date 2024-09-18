Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# 상수 정의
$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 1
$SPIF_SENDCHANGE = 2

# Function to get the primary screen resolution
function Get-ScreenResolution {
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $width = $screen.Bounds.Width
    $height = $screen.Bounds.Height
    return "$width x $height"
}

# Define the paths to the wallpaper images
$wallpaperPath1 = "C:\Sohn\wallpaper\untitled(1).png"
$wallpaperPath2 = "C:\Sohn\wallpaper\untitled(2).png"

# Define the resolution settings
$resolution1 = "2560 x 1080"
$resolution2 = "1920 x 1080"

# Function to set the wallpaper using Windows API
function Set-Wallpaper {
    param (
        [string]$path
    )
    $path = [System.IO.Path]::GetFullPath($path)
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $path, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
}

# Get the current screen resolution
try {
    $resolution = Get-ScreenResolution
    Write-Output "Current Resolution: $resolution"
    
    # Check resolution and set wallpaper
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
