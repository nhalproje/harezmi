Add-Type -AssemblyName System.IO.Compression.FileSystem
$docxFile = Get-ChildItem "c:\Users\BTLab\Desktop\harezmi site" -Filter "*.docx" | Select-Object -First 1
if (-not $docxFile) {
    Write-Host "Error: No .docx file found in directory"
    exit
}
$docxPath = $docxFile.FullName
$outputPath = "c:\Users\BTLab\Desktop\harezmi site\hipatia_raw_text.txt"

Write-Host "Found file: $docxPath"
$zip = [System.IO.Compression.ZipFile]::OpenRead($docxPath)
$entry = $zip.Entries | Where-Object { $_.FullName -eq "word/document.xml" }
if ($entry) {
    $stream = $entry.Open()
    $reader = New-Object System.IO.StreamReader($stream)
    $xmlText = $reader.ReadToEnd()
    $reader.Close()
    $stream.Close()
    $zip.Dispose()

    $xml = [xml]$xmlText
    $paragraphs = $xml.SelectNodes("//*[local-name()='p']")
    $outputText = foreach ($p in $paragraphs) {
        $texts = $p.SelectNodes(".//*[local-name()='t']")
        $pText = ($texts | ForEach-Object { $_.InnerText }) -join ""
        $pText
    }
    $outputText | Out-File -FilePath $outputPath -Encoding utf8
    Write-Host "Success: Content extracted to $outputPath"
} else {
    $zip.Dispose()
    Write-Host "Error: word/document.xml not found in docx file"
}
