const mongoose = require('mongoose');
const Book = require('./src/model/Book');
require('dotenv').config();

async function checkBook() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('✅ Connected to MongoDB');

        // Find book by title (case-insensitive for safety)
        const book = await Book.findOne({ title: { $regex: /Cabas/i } });

        if (book) {
            console.log('📖 Book Found:');
            console.log('Title:', book.title);
            console.log('PDF URL (Raw from DB):', book.pdfUrl);
            console.log('Cover Image (Raw from DB):', book.coverImage);
        } else {
            console.log('❌ Book "Cabas" not found.');
            // List all books to see what we have
            const allBooks = await Book.find({}, 'title pdfUrl');
            console.log('📚 All Books:', allBooks);
        }

    } catch (e) {
        console.error('❌ Error:', e);
    } finally {
        await mongoose.disconnect();
    }
}

checkBook();
