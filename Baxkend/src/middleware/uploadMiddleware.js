const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure upload directories exist
const uploadDirs = [
  'uploads/',
  'uploads/books',
  'uploads/books/covers',
  'uploads/books/pdfs'
];

uploadDirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
    console.log(`✅ Created directory: ${dir}`);
  }
});

// Configure storage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Organize files by type
    if (file.fieldname === 'coverImage') {
      cb(null, 'uploads/books/covers');
    } else if (file.fieldname === 'pdfUrl') {
      cb(null, 'uploads/books/pdfs');
    } else {
      cb(null, 'uploads/');
    }
  },
  filename: function (req, file, cb) {
    // Generate unique filename with timestamp
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

// File filter for validation
const fileFilter = (req, file, cb) => {
  if (file.fieldname === 'coverImage') {
    // Accept images only
    const allowedImageTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedImageTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedImageTypes.test(file.mimetype);
    
    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('Only image files (JPEG, PNG, GIF, WebP) are allowed for cover images'));
    }
  } else if (file.fieldname === 'pdfUrl') {
    // Accept PDFs only
    const isPdf = file.mimetype === 'application/pdf';
    
    if (isPdf) {
      return cb(null, true);
    } else {
      cb(new Error('Only PDF files are allowed for book files'));
    }
  } else {
    cb(null, true);
  }
};

const upload = multer({ 
  storage: storage,
  limits: { 
    fileSize: 50 * 1024 * 1024, // 50MB max
  },
  fileFilter: fileFilter
});

module.exports = upload;
