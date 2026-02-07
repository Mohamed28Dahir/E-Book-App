const mongoose = require('mongoose');

const BookSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  author: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
    enum: ['Story', 'Love', 'Education', 'Islamic', 'History'],
  },
  coverImage: {
    type: String, // URL/Path to image
  },
  pdfUrl: {
    type: String, // URL/Path to PDF
  },
  rating: {
    type: Number,
    default: 0,
  },
  pages: {
    type: Number,
  },
  description: {
    type: String,
  },
  color: {
    type: String, // Hex color code
    default: '#2D6A4F',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Book', BookSchema);
