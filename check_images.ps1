[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
Get-ChildItem "resimler\*" -Include *.png, *.jpg, *.jpeg | ForEach-Object {
    try {
        $img = [System.Drawing.Image]::FromFile($_.FullName)
        Write-Output ($_.Name + ": " + $img.Width + "x" + $img.Height)
        $img.Dispose()
    } catch {
        # ignore non-image files or errors
    }
}
