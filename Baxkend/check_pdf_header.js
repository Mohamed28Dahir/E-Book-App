const mongoose = require('mongoose');
const Book = require('./src/model/Book');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function checkBook() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        const book = await Book.findOne({ title: { $regex: /Cabas/i } });

        if (book) {
            console.log('Book found: ' + book.title);
            let p = book.pdfUrl.replace(/\\/g, '/');
            if (p.startsWith('/')) p = p.substring(1);

            const fullPath = path.join(__dirname, p);
            console.log('Path: ' + fullPath);

            if (fs.existsSync(fullPath)) {
                const stats = fs.statSync(fullPath);
                console.log('Size: ' + stats.size + ' bytes');

                const buffer = Buffer.alloc(20);
                const fd = fs.openSync(fullPath, 'r');
                fs.readSync(fd, buffer, 0, 20, 0);
                fs.closeSync(fd);

                console.log('Header (Hex): ' + buffer.toString('hex'));
                console.log('Header (String): ' + buffer.toString('utf8'));

                if (buffer.toString('utf8').startsWith('%PDF')) {
                    console.log('✅ VALID PDF HEADER');
                } else {
                    console.log('❌ INVALID PDF HEADER');
                }
            } else {
                console.log('❌ File not found at calculated path.');
            }
        }
    } catch (e) {
        console.error(e);
    } finally {
        await mongoose.disconnect();
    }
}

checkBook();
