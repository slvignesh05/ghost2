# Run this from inside C:\Users\Vignesh\Desktop\Ghost\images
# It renames every PNG to ghost-001.png, ghost-002.png, ... in order,
# and prints the IMAGES array block for index.html (also saves it to
# images-array.txt in the same folder).

$files = Get-ChildItem -Path . -Filter *.png | Sort-Object Name

$entries = @()
$i = 1

foreach ($f in $files) {
    # Pull the date/time out of the original filename, e.g.
    # "...Screenshot 2025.07.07 - 13.50.55.28.png"
    $caption = ""
    if ($f.Name -match '(\d{4}\.\d{2}\.\d{2})\s*-\s*(\d{2})\.(\d{2})\.(\d{2})') {
        $datePart = $matches[1] -replace '\.', '-'
        $caption = "$datePart at $($matches[2]):$($matches[3]):$($matches[4])"
    }

    $newName = "ghost-{0:D3}.png" -f $i
    Rename-Item -Path $f.FullName -NewName $newName

    $entries += "  { file: `"images/$newName`", title: `"Ghost of Tsushima $i`", desc: `"$caption`" },"
    $i++
}

$block = "const IMAGES = [`n" + ($entries -join "`n") + "`n];"

$block | Out-File -FilePath ".\images-array.txt" -Encoding utf8

Write-Host ""
Write-Host "Done. Renamed $($files.Count) files." -ForegroundColor Green
Write-Host "Paste the block below into index.html (replacing the existing IMAGES array),"
Write-Host "or open images-array.txt in this folder to copy it from there."
Write-Host ""
Write-Host $block