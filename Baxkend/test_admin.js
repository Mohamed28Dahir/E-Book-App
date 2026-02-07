const axios = require('axios');
const mongoose = require('mongoose');
const User = require('./src/model/User');
const Book = require('./src/model/Book');
require('dotenv').config();

const API_URL = 'http://localhost:3002/api';
const AUTH_URL = 'http://localhost:3002/api/auth';
const MONGO_URI = process.env.MONGO_URI;

async function runAdminTests() {
  try {
    console.log('🚀 Starting Admin API Tests...');

    // 1. Setup Data
    await mongoose.connect(MONGO_URI);
    // Create an admin user if not exists or reset
    await User.deleteMany({ username: 'admin_tester' });
    const adminUser = new User({
        fullname: 'Admin Tester',
        username: 'admin_tester',
        password: 'password123',
        role: 'admin',
        phone: '1234567890',
        gender: 'Male'
    });
    // Hashing is handled in pre-save? I need to check User model. 
    // Assuming User model has pre-save hook for hashing.
    // If controller does hashing manually, I might need to use the register API or check model.
    // Let's use the signup API then promote.
    
    // Actually, let's use the API to ensure hashing is correct.
    
    // Signup as normal user
    try {
        await axios.post(`${AUTH_URL}/signup`, {
            fullname: 'Admin Tester',
            username: 'admin_tester',
            password: 'password123',
            role: 'admin', // Trying to set admin directly? Backend might ignore or allow.
            phone: '1234567890',
            gender: 'Male'
        });
    } catch(e) {
        // Ignore if exists, or handle
    }
    
    // Force promote to admin in DB to be sure
    await User.updateOne({ username: 'admin_tester' }, { role: 'admin' });
    
    // Login to get Token
    let token;
    try {
        const res = await axios.post(`${AUTH_URL}/login`, {
            username: 'admin_tester',
            password: 'password123'
        });
        token = res.data.token;
        console.log('✅ Admin Login Successful');
    } catch (e) {
        console.error('❌ Admin Login Failed', e.response?.data || e.message);
        return;
    }

    const config = {
        headers: { 'x-auth-token': token }
    };

    // 2. Test User Management (Admin Only)
    console.log('\n--- Testing User Management ---');
    
    // Create User via Admin API
    let createdUserId;
    try {
        const res = await axios.post(`${API_URL}/users`, {
            fullname: 'Managed User',
            username: 'managed_user',
            password: 'password123',
            role: 'user',
            phone: '1112223333',
            gender: 'Female'
        }, config);
        createdUserId = res.data.user && res.data.user._id ? res.data.user._id : (res.data._id || null);
        // Note: Controller returns { msg, user: {username...} } or user obj?
        // Looking at controller: res.json({ msg: ..., user: { ... } }); - It DOES NOT return _id.
        // Wait, the controller addUser returns: res.json({ msg: '...', user: { username, role, fullname } });
        // It does NOT return the _id! I need to fix the controller to return _id if I want to use it.
        // Or I can fetch the user by username to get ID.
        console.log('✅ Admin: Create User Successful');
    } catch (e) {
        console.error('❌ Admin: Create User Failed', e.response?.data || e.message);
    }

    // Get Users to find the ID if needed
    if (!createdUserId) {
        try {
            const res = await axios.get(`${API_URL}/users`, config);
            const found = res.data.find(u => u.username === 'managed_user');
            if (found) createdUserId = found._id;
            console.log(`✅ Admin: Get Users Successful (Count: ${res.data.length})`);
        } catch (e) {
            console.error('❌ Admin: Get Users Failed', e.response?.data || e.message);
        }
    }

    // Get User By ID
    if (createdUserId) {
        try {
            const res = await axios.get(`${API_URL}/users/${createdUserId}`, config);
            if (res.data._id === createdUserId) console.log('✅ Admin: Get User By ID Successful');
            else console.error('❌ Admin: Get User By ID returned wrong ID');
        } catch(e) {
            console.error('❌ Admin: Get User By ID Failed', e.response?.data || e.message);
        }

        // Update User
        try {
             const res = await axios.put(`${API_URL}/users/${createdUserId}`, {
                 fullname: 'Updated Name',
                 role: 'admin' // Try promoting
             }, config);
             if (res.data.fullname === 'Updated Name') console.log('✅ Admin: Update User Successful');
        } catch(e) {
             console.error('❌ Admin: Update User Failed', e.response?.data || e.message);
        }
    }

    // Delete User
    if (createdUserId) {
        try {
            await axios.delete(`${API_URL}/users/${createdUserId}`, config);
            console.log('✅ Admin: Delete User Successful');
        } catch (e) {
            console.error('❌ Admin: Delete User Failed', e.response?.data || e.message);
        }
    }

    // 3. Test Book Management (Admin Only)
    console.log('\n--- Testing Book Management ---');
    
    // Insert a Book manually via Mongoose to test GetById (since API needs multipart)
    let testBookId;
    try {
        const book = new Book({
            title: 'Test Book JS',
            author: 'Tester',
            category: 'Story',
            description: 'A test book',
            pages: 100
        });
        await book.save();
        testBookId = book._id.toString();
        console.log('✅ Manual Book Insert Successful');
    } catch(e) {
        console.error('❌ Manual Book Insert Failed', e);
    }

    // Get Books
    try {
        const res = await axios.get(`${API_URL}/books`, config);
        if (Array.isArray(res.data) && res.data.length > 0) console.log(`✅ Admin: Get Books Successful (Count: ${res.data.length})`);
    } catch (e) {
        console.error('❌ Admin: Get Books Failed', e.response?.data || e.message);
    }

    // Get Book By ID
    if (testBookId) {
        try {
            const res = await axios.get(`${API_URL}/books/${testBookId}`, config);
            if (res.data._id === testBookId) console.log('✅ Admin: Get Book By ID Successful');
        } catch (e) {
            console.error('❌ Admin: Get Book By ID Failed', e.response?.data || e.message);
        }
        
        // Cleanup Book
        await Book.findByIdAndDelete(testBookId);
    }

  } catch (err) {
    console.error('❌ Test Script Error:', err);
  } finally {
    // Cleanup
    await User.deleteMany({ username: 'admin_tester' });
    await mongoose.disconnect();
  }
}

runAdminTests();
