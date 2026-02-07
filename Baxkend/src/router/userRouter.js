const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');
const auth = require('../middleware/authMiddleware');
const role = require('../middleware/roleMiddleware');

// Auth middleware for all routes
router.use(auth);

// Public/User routes (Authenticated)
router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);
router.put('/update-username', userController.updateUsername);

// Favorites & History (Authenticated Users)
router.get('/favorites', userController.getFavorites);
router.post('/favorite', userController.addFavorite);
router.delete('/favorites/:bookId', userController.removeFavorite);

router.get('/history', userController.getHistory);
router.post('/history/:bookId', userController.addToHistory);

// Admin Only Middleware
router.use(role(['admin']));

router.get('/', userController.getUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.addUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

module.exports = router;
