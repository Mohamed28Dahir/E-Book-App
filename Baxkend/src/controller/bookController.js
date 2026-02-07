const Book = require('../model/Book');

// Get all books
exports.getBooks = async (req, res) => {
  try {
    const books = await Book.find().sort({ createdAt: -1 });
    res.json(books);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// Get book by ID
exports.getBookById = async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ msg: 'Book not found' });
    }
    res.json(book);
  } catch (err) {
    console.error(err.message);
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ msg: 'Book not found' });
    }
    res.status(500).send('Server Error');
  }
};

// Add a book
exports.addBook = async (req, res) => {
  try {
    const { title, author, category, description, color, rating, pages } = req.body;
    
    // Validation
    if (!title || !author || !category) {
      return res.status(400).json({ msg: 'Title, Author, and Category are required' });
    }
    
    // Handle file uploads safely
    let coverImage = null;
    let pdfUrl = null;
    
    if (req.files && req.files['coverImage']) {
      coverImage = req.files['coverImage'][0].path;
    }
    
    if (req.files && req.files['pdfUrl']) {
      pdfUrl = req.files['pdfUrl'][0].path;
    }

    const newBook = new Book({
      title,
      author,
      category,
      description: description || '',
      color: color || '#2D6A4F',
      rating: rating ? parseFloat(rating) : 0,
      pages: pages ? parseInt(pages) : 0,
      coverImage,
      pdfUrl,
    });

    const book = await newBook.save();
    console.log('✅ Book created:', book._id);
    res.json(book);
  } catch (err) {
    console.error('❌ Error adding book:', err.message);
    res.status(500).json({ error: 'Server Error', details: err.message });
  }
};

// Update a book
exports.updateBook = async (req, res) => {
  try {
    const { title, author, category, description, color, rating, pages } = req.body;
    
    let book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ msg: 'Book not found' });
    }

    const bookFields = {};
    if (title) bookFields.title = title;
    if (author) bookFields.author = author;
    if (category) bookFields.category = category;
    if (description) bookFields.description = description;
    if (color) bookFields.color = color;
    if (rating) bookFields.rating = parseFloat(rating);
    if (pages) bookFields.pages = parseInt(pages);
    
    // Handle file updates safely
    if (req.files && req.files['coverImage']) {
      bookFields.coverImage = req.files['coverImage'][0].path;
    }
    
    if (req.files && req.files['pdfUrl']) {
      bookFields.pdfUrl = req.files['pdfUrl'][0].path;
    }

    book = await Book.findByIdAndUpdate(
      req.params.id,
      { $set: bookFields },
      { new: true }
    );
    
    console.log('✅ Book updated:', book._id);
    res.json(book);
  } catch (err) {
    console.error('❌ Error updating book:', err.message);
    res.status(500).json({ error: 'Server Error', details: err.message });
  }
};

// Delete a book
exports.deleteBook = async (req, res) => {
  try {
    // In Mongoose v6+, findByIdAndRemove is deprecated in favor of findByIdAndDelete
    // but check version or use deprecated one if older. Using findByIdAndDelete is safe.
    let book = await Book.findById(req.params.id);
    if (!book) return res.status(404).json({ msg: 'Book not found' });

    await Book.findByIdAndDelete(req.params.id);
    res.json({ msg: 'Book removed' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};
