# Tüm HTML dosyalarinda emoji blogunu temiz bicimde degistir
# PowerShell'de Unicode emoji'leri [char] ile kullaniyoruz

$siteDir = "c:\Users\BTLab\Desktop\harezmi site"

# Emojileri [char] ile tanimla
$palette  = [char]0x1F3A8  # 🎨
$brush    = [char]0x1F58C  # 🖌
$fe0f     = [char]0xFE0F   # variation selector
$crayon   = [char]0x1F58D  # 🖍
$pencil   = [char]0x270F   # ✏
$frame    = [char]0x1F5BC  # 🖼

$p  = "$palette"
$br = "$brush$fe0f"
$cr = "$crayon$fe0f"
$pe = "$pencil$fe0f"
$fr = "$frame$fe0f"

$newBlock = @"
    <div class="flowers" aria-hidden="true">
        <span class="flower f1">$p</span>
        <span class="flower f2">$br</span>
        <span class="flower f3">$cr</span>
        <span class="flower f4">$pe</span>
        <span class="flower f5">$br</span>
        <span class="flower f6">$p</span>
        <span class="flower f7">$cr</span>
        <span class="flower f8">$fr</span>
        <span class="flower f9">$p</span>
        <span class="flower f10">$br</span>
        <span class="flower f11">$cr</span>
        <span class="flower f12">$p</span>
        <span class="flower f13">$br</span>
        <span class="flower f14">$pe</span>
        <span class="flower f15">$cr</span>
        <span class="flower f16">$p</span>
    </div>
"@

# anasayfa.html zaten duzeltildi, atla
$skip = @("anasayfa.html")

$pages = Get-ChildItem -Path $siteDir -Filter "*.html" | Where-Object { $skip -notcontains $_.Name }

$count = 0
foreach ($page in $pages) {
    # UTF-8 BOM olmadan oku
    $content = [System.IO.File]::ReadAllText($page.FullName, [System.Text.Encoding]::UTF8)

    if ($content -notmatch 'class="flowers"') { continue }

    # flowers blogunu degistir
    $newContent = [regex]::Replace($content, '(?s)<div class="flowers"[^>]*>.*?</div>', $newBlock)

    if ($newContent -ne $content) {
        [System.IO.File]::WriteAllText($page.FullName, $newContent, [System.Text.Encoding]::UTF8)
        $count++
        Write-Host "OK: $($page.Name)"
    }
}

Write-Host ""
Write-Host "Bitti! $count sayfa guncellendi." -ForegroundColor Cyan
