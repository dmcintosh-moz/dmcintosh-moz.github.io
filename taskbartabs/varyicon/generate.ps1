function Generate-SVG {
  param ($Size)
  $size = $Size
  $red = (128 * [math]::Cos($size)) + 128
  $blue = (128 * [math]::Sin($size)) + 128
  Write-Output '<?xml version="1.0" encoding="utf-8"?>
<svg width="'$size'" height="'$size'" viewBox="0 0 1 1" xmlns="http://www.w3.org/2000/svg">
  <!-- I wanted to use HSL or okLCH, but Inkscape doesn_t support them?!? -->
  <rect width="1" height="1" fill="rgb('$red', '140', '$blue')" /><!-- fill="hsl('$hue'deg, 100%, 50%)" />-->
  <text x="0" y="1" style="font-family: sans-serif; font-size: 0.125px;">'$size'x'$size'</text>
</svg>
'
}

$sizes = @(16, 32, 64, 128, 196, 256, 384, 512, 1024)
foreach ($size in $sizes) {
  Write-Host "writing icon-$($size).svg"
  Generate-SVG -Size $size | Out-File -Encoding "utf-8" -FilePath "icon-$($size).svg";
}

Write-Host "writing favicon.svg"
Generate-SVG -Size 156 | Out-File -Encoding "utf-8" -FilePath "favicon.svg";

Write-Host "converting SVGs into PNGs"
& 'C:\Program Files\Inkscape\bin\inkscape' --export-type=png $($sizes | Foreach-Object { "icon-$($_).svg" }) favicon.svg

Write-Host "writing manifest.json"
$manifest = @{
  "name" = "Varyicon";
  "icons" = ($sizes | Foreach-Object { @{
    "src" = "icon-$($_).png";
    "sizes" = "$($_)x$($_)";
  } });
  "start_url" = "/taskbartabs/varyicon";
  "scope" = "/taskbartabs/varyicon";
  "display" = "minimal-ui";
};
$manifest | ConvertTo-JSON | Out-File -Encoding "utf-8" -FilePath "manifest.json";

Write-Host "done!";

