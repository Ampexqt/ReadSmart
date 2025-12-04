# PowerShell script to resize and copy app icon to Android mipmap folders
# This script uses .NET System.Drawing to resize images

Add-Type -AssemblyName System.Drawing

$sourcePath = "assets\images\app-icon.png"
$baseOutputPath = "android\app\src\main\res"

# Define the sizes for each density
$sizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

# Load the source image
$sourceImage = [System.Drawing.Image]::FromFile((Resolve-Path $sourcePath))

foreach ($folder in $sizes.Keys) {
    $size = $sizes[$folder]
    $outputFolder = Join-Path $baseOutputPath $folder
    $outputPath = Join-Path $outputFolder "ic_launcher.png"
    
    # Create a new bitmap with the target size
    $resizedImage = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
    
    # Set high quality rendering
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Draw the resized image
    $graphics.DrawImage($sourceImage, 0, 0, $size, $size)
    
    # Save the resized image
    $resizedImage.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Clean up
    $graphics.Dispose()
    $resizedImage.Dispose()
    
    Write-Host "Created $outputPath ($size x $size)"
}

# Clean up source image
$sourceImage.Dispose()

Write-Host "`nApp icons generated successfully!"
