// fix_brushes.js
// Python fix_brushes.py dosyasının JavaScript karşılığı.
// Kullanım: node fix_brushes.js
// Tüm HTML sayfalarındaki .flowers bloğunu
// kalem/boya fırçası/palet emojileriyle günceller.

const fs = require('fs');
const path = require('path');

const siteDir = path.resolve(__dirname);

const BRUSH_BLOCK = `    <div class="flowers" aria-hidden="true">
        <span class="flower f1">🎨</span>
        <span class="flower f2">🖌️</span>
        <span class="flower f3">🖍️</span>
        <span class="flower f4">✏️</span>
        <span class="flower f5">🖌️</span>
        <span class="flower f6">🎨</span>
        <span class="flower f7">🖍️</span>
        <span class="flower f8">🖼️</span>
        <span class="flower f9">🎨</span>
        <span class="flower f10">🖌️</span>
        <span class="flower f11">🖍️</span>
        <span class="flower f12">🎨</span>
        <span class="flower f13">🖌️</span>
        <span class="flower f14">✏️</span>
        <span class="flower f15">🖍️</span>
        <span class="flower f16">🎨</span>
    </div>`;

// anasayfa.html zaten düzeltildi, atla
const skip = new Set(['anasayfa.html']);

let count = 0;
const files = fs.readdirSync(siteDir).filter(f => f.endsWith('.html'));

for (const fname of files) {
    if (skip.has(fname)) continue;

    const fpath = path.join(siteDir, fname);
    let content = fs.readFileSync(fpath, 'utf-8');

    if (!content.includes('class="flowers"')) continue;

    // flowers bloğunu yenisiyle değiştir
    const newContent = content.replace(
        /<div class="flowers"[\s\S]*?<\/div>/,
        BRUSH_BLOCK
    );

    if (newContent !== content) {
        fs.writeFileSync(fpath, newContent, 'utf-8');
        count++;
        console.log(`✅ Güncellendi: ${fname}`);
    } else {
        console.log(`⏭  Atlandı:    ${fname}`);
    }
}

console.log(`\n🎨 Toplam ${count} sayfa güncellendi!`);
