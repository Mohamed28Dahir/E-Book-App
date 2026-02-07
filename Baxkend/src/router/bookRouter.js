const express = require('express');
const router = express.Router();
const bookController = require('../controller/bookController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');
const upload = require('../middleware/uploadMiddleware');

// Public route to view books
router.get('/', bookController.getBooks);
router.get('/:id', bookController.getBookById);

// Admin only routes
router.post(
  '/',
  [auth, role(['admin']), upload.fields([{ name: 'coverImage', maxCount: 1 }, { name: 'pdfUrl', maxCount: 1 }])],
  bookController.addBook
);

router.put(
  '/:id',
  [auth, role(['admin']), upload.fields([{ name: 'coverImage', maxCount: 1 }, { name: 'pdfUrl', maxCount: 1 }])],
  bookController.updateBook
);

router.delete('/:id', [auth, role(['admin'])], bookController.deleteBook);

module.exports = router;
