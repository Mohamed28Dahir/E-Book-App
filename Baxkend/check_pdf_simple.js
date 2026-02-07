const mongoose = require('mongoose');
const Book = require('./src/model/Book');
require('dotenv').config();

async function checkBook() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        const book = await Book.findOne({ title: { $regex: /Cabas/i } });

        if (book) {
            console.log('PDF_URL_VALUE: ' + book.pdfUrl);
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
