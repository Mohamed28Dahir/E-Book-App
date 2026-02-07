const express = require('express');
const router = express.Router();
const authController = require('../controller/authController');
const auth = require('../middleware/authMiddleware');

// @route   POST api/auth/signup
// @desc    Register user
// @access  Public
router.post('/signup', authController.signup);

// @route   POST api/auth/login
// @desc    Authenticate user & get token
// @access  Public
router.post('/login', authController.login);

// @route   POST api/auth/forgot-password
// @desc    Update password
// @access  Public (Conceptually, usually requires email verification, but here it's simplified)
router.post('/forgot-password', authController.forgotPassword);

// @route   POST api/auth/verify-username
// @desc    Verify if user exists
// @access  Public
router.post('/verify-username', authController.verifyUsername);

module.exports = router;
