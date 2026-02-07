const axios = require('axios');
const mongoose = require('mongoose');
const User = require('./src/model/User');
require('dotenv').config();

const API_URL = 'http://localhost:3000/api/auth';
const MONGO_URI = process.env.MONGO_URI;

async function runTests() {
  try {
    // 1. Clean DB
    await mongoose.connect(MONGO_URI);
    await User.deleteMany({ username: 'testuser' });
    console.log('✅ DB Cleaned');

    // 2. Signup
    console.log('Testing Signup...');
    try {
        await axios.post(`${API_URL}/signup`, {
        fullname: 'Test User',
        phone: '1234567890',
        gender: 'Male',
        username: 'testuser',
        password: 'password123'
        });
        console.log('✅ Signup Successful');
    } catch (e) {
        console.error('❌ Signup Failed', e.response?.data || e.message);
    }

    // 3. Login (Normal User)
    console.log('Testing Login (User)...');
    let token;
    try {
        const res = await axios.post(`${API_URL}/login`, {
        username: 'testuser',
        password: 'password123'
        });
        token = res.data.token;
        if (res.data.role === 'user') console.log('✅ Login (User) Successful');
        else console.error('❌ Login Role Mismatch');
    } catch (e) {
        console.error('❌ Login Failed', e.response?.data || e.message);
    }

    // 4. Promote to Admin (Manual DB Op)
    console.log('Promoting to Admin...');
    await User.updateOne({ username: 'testuser' }, { role: 'admin' });
    console.log('✅ Promoted to Admin');

    // 5. Login (Admin)
    console.log('Testing Login (Admin)...');
    try {
        const res = await axios.post(`${API_URL}/login`, {
        username: 'testuser',
        password: 'password123'
        });
        if (res.data.role === 'admin') console.log('✅ Login (Admin) Successful');
        else console.error('❌ Login Role Mismatch');
    } catch (e) {
        console.error('❌ Login Failed', e.response?.data || e.message);
    }

    // 6. Forgot Password
    console.log('Testing Forgot Password...');
    try {
        await axios.post(`${API_URL}/forgot-password`, {
        username: 'testuser',
        newPassword: 'newpassword123'
        });
        console.log('✅ Forgot Password Successful');
    } catch (e) {
        console.error('❌ Forgot Password Failed', e.response?.data || e.message);
    }

    // 7. Login with New Password
    console.log('Testing Login with New Password...');
    try {
        await axios.post(`${API_URL}/login`, {
        username: 'testuser',
        password: 'newpassword123'
        });
        console.log('✅ Login (New Password) Successful');
    } catch (e) {
        console.error('❌ Login (New Password) Failed', e.response?.data || e.message);
    }

  } catch (err) {
    console.error('❌ Test Script Error:', err);
  } finally {
    await mongoose.disconnect();
  }
}

runTests();
