const express = require('express');
const connectDB = require('./src/config/db');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();

// Connect Database
connectDB();

// Init Middleware
app.use(express.json({ extended: false }));
app.use(cors());

// Simple Request Logger
app.use((req, res, next) => {
    console.log(`[REQUEST] ${req.method} ${req.url}`);
    next();
});

// Serve Static Files (Uploads)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Define Routes
app.use('/api/auth', require('./src/router/authRouter'));
app.use('/api/users', require('./src/router/userRouter'));
app.use('/api/books', require('./src/router/bookRouter'));
app.use('/api/dashboard', require('./src/router/dashboardRouter'));

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
    console.log('Routes loaded: /api/auth, /api/books, /api/users');
});
