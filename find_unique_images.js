const fs = require('fs');
const path = require('path');

const resimlerDir = 'c:/Users/BTLab/Desktop/harezmi site/resimler';
const kalanlarDir = 'c:/Users/BTLab/Desktop/harezmi site/kalanlar';
const harezminotesDir = 'c:/Users/BTLab/Desktop/harezmi site/harezminotes';

// Get sizes of files in kalanlar
const kalanlarSizes = {};
fs.readdirSync(kalanlarDir).forEach(file => {
    const stat = fs.statSync(path.join(kalanlarDir, file));
    if (stat.isFile()) {
        kalanlarSizes[stat.size] = file;
    }
});

// Get sizes of files in harezminotes
const harezmiSizes = {};
fs.readdirSync(harezminotesDir).forEach(file => {
    const stat = fs.statSync(path.join(harezminotesDir, file));
    if (stat.isFile()) {
        harezmiSizes[stat.size] = file;
    }
});

const uniqueImages = [];
const duplicateImages = [];

fs.readdirSync(resimlerDir).forEach(file => {
    const filePath = path.join(resimlerDir, file);
    const stat = fs.statSync(filePath);
    if (!stat.isFile()) return;

    if (kalanlarSizes[stat.size]) {
        duplicateImages.push({
            file: file,
            size: stat.size,
            matchDir: 'kalanlar',
            matchFile: kalanlarSizes[stat.size]
        });
    } else if (harezmiSizes[stat.size]) {
        duplicateImages.push({
            file: file,
            size: stat.size,
            matchDir: 'harezminotes',
            matchFile: harezmiSizes[stat.size]
        });
    } else {
        uniqueImages.push({
            file: file,
            size: stat.size
        });
    }
});

console.log(`Duplicate files count: ${duplicateImages.length}`);
console.log(`Unique files count: ${uniqueImages.length}`);

console.log('\n--- UNIQUE IMAGES ---');
uniqueImages.forEach(img => {
    console.log(`${img.file} (${(img.size / 1024 / 1024).toFixed(2)} MB)`);
});
