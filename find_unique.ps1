$kalanlar = @{}
Get-ChildItem "kalanlar\*" -File | ForEach-Object { $kalanlar[$_.Length] = $_.Name }
$harezmi = @{}
Get-ChildItem "harezminotes\*" -File | ForEach-Object { $harezmi[$_.Length] = $_.Name }

$unique = @()
$dup = @()
Get-ChildItem "resimler\*" -File | ForEach-Object {
    if ($kalanlar.ContainsKey($_.Length)) {
        $dup += [PSCustomObject]@{ File = $_.Name; Size = $_.Length; Match = "kalanlar\" + $kalanlar[$_.Length] }
    } elseif ($harezmi.ContainsKey($_.Length)) {
        $dup += [PSCustomObject]@{ File = $_.Name; Size = $_.Length; Match = "harezminotes\" + $harezmi[$_.Length] }
    } else {
        $unique += [PSCustomObject]@{ File = $_.Name; Size = $_.Length }
    }
}

Write-Output "Unique: $($unique.Count), Duplicates: $($dup.Count)"
Write-Output "`n--- UNIQUE IMAGES ---"
$unique | ForEach-Object { Write-Output "$($_.File) ($([Math]::Round($_.Size / 1MB, 2)) MB)" }
