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
            console.log('DB_VALUE_JSON: ' + JSON.stringify(book.pdfUrl));

            // value is likely "uploads\\..." or "uploads/..."
            // We want to check if it exists relative to current directory (Baxkend)
            // But wait, if it starts with "uploads", and we are in Baxkend, then:
            const relativePath = book.pdfUrl.replace(/\\/g, '/'); // Normalize to forward slashes
            const fullPath = path.join(__dirname, relativePath);

            console.log('CHECKING_PATH: ' + fullPath);

            if (fs.existsSync(fullPath)) {
                console.log('✅ FILE EXISTS on disk.');
            } else {
                console.log('❌ FILE DOES NOT EXIST on disk.');

                // Try to find if it exists in books/pdfs
                const fileName = path.basename(relativePath);
                const alternativePath = path.join(__dirname, 'uploads', 'books', 'pdfs', fileName);
                console.log('CHECKING_ALTERNATIVE: ' + alternativePath);
                if (fs.existsSync(alternativePath)) {
                    console.log('✅ Found at alternative path. DB path is INCORRECT.');
                } else {
                    console.log('❌ Still not found.');
                }
            }

        } else {
            console.log('Book not found');
        }
    } catch (e) {
        console.error(e);
    } finally {
        await mongoose.disconnect();
    }
}

checkBook();
