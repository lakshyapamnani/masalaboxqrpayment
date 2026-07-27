Add-Type -AssemblyName System.Drawing

$src = "C:\Users\LAKSHYA\.gemini\antigravity-ide\brain\389d1612-572c-45e9-a534-14f20d536c1a\pwa_icon_1785164168148.png"
if (-Not (Test-Path $src)) {
    Write-Error "Source image not found: $src"
    exit 1
}

$img = [System.Drawing.Image]::FromFile($src)

function Resize-Save($w, $destPath) {
    Write-Host "Resizing to $w x $w -> $destPath"
    $bmp = New-Object System.Drawing.Bitmap($w, $w)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    
    # Use high quality resizing settings
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    $g.DrawImage($img, 0, 0, $w, $w)
    $bmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $g.Dispose()
    $bmp.Dispose()
}

# Create output folder if not exist
if (-Not (Test-Path "public")) {
    New-Item -ItemType Directory -Path "public"
}

Resize-Save 192 "public/pwa-192x192.png"
Resize-Save 512 "public/pwa-512x512.png"
Resize-Save 180 "public/apple-touch-icon.png"

$img.Dispose()
Write-Host "PWA Icons generated successfully!"
