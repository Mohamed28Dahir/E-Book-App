const axios = require('axios');
const mongoose = require('mongoose');
const User = require('./src/model/User');
require('dotenv').config();

const API_URL = 'http://localhost:3003/api';
const MONGO_URI = process.env.MONGO_URI;

let userToken;
let adminToken;

async function runTests() {
  try {
    console.log('🚀 Starting User & Dashboard API Tests...');
    
    // 1. Setup Data via Mongoose
    await mongoose.connect(MONGO_URI);
    
    // Setup Admin
    await User.deleteMany({ username: 'final_admin' });
    const adminUser = new User({
        fullname: 'Final Admin',
        username: 'final_admin',
        password: 'password123', // Will be hashed if pre-save hook exists, else plaintext? 
        // User controller hashes it. Manual insert might NOT hash if schema doesn't have pre-save.
        // Let's use the API to create them to ensure hashing is correct!
        role: 'admin',
        phone: '1234567890',
        gender: 'Male'
    });
    // Actually, simple way: delete them, then use SIGNUP API.
    
    await User.deleteMany({ username: 'final_admin' });
    await User.deleteMany({ username: 'final_user' });
    
    console.log('--- Creating Users via API ---');
    
    // Create Admin (Signup then promote)
    try {
        await axios.post(`${API_URL}/auth/signup`, {
             fullname: 'Final Admin',
             username: 'final_admin',
             password: 'password123',
             phone: '0000000000',
             gender: 'Male'
        });
        // Promote to admin directly via DB
        await User.updateOne({ username: 'final_admin' }, { role: 'admin' });
        console.log('✅ Admin Created & Promoted');
    } catch (e) {
        console.error('❌ Admin Creation Failed', e.response?.data || e.message);
    }

    // Create User
    try {
        await axios.post(`${API_URL}/auth/signup`, {
             fullname: 'Final User',
             username: 'final_user',
             password: 'password123',
             phone: '1111111111',
             gender: 'Female'
        });
        console.log('✅ User Created');
    } catch (e) {
        console.error('❌ User Creation Failed', e.response?.data || e.message);
    }

    // 2. Login
    try {
        const res = await axios.post(`${API_URL}/auth/login`, {
            username: 'final_admin',
            password: 'password123'
        });
        adminToken = res.data.token;
        console.log('✅ Admin Login Successful');
    } catch (e) {
        console.error('❌ Admin Login Failed', e.response?.data || e.message);
    }

    try {
        const res = await axios.post(`${API_URL}/auth/login`, {
            username: 'final_user',
            password: 'password123'
        });
        userToken = res.data.token;
        console.log('✅ User Login Successful');
    } catch (e) {
        console.error('❌ User Login Failed', e.response?.data || e.message);
    }

    // 3. Test Dashboard Stats (Admin Only)
    if (adminToken) {
        try {
            const res = await axios.get(`${API_URL}/dashboard/stats`, {
                headers: { 'x-auth-token': adminToken }
            });
            if (res.data.totalUsers !== undefined) {
                 console.log(`✅ Dashboard Stats Verified: Users=${res.data.totalUsers}, Books=${res.data.totalBooks}`);
            } else {
                 console.error('❌ Dashboard Stats Invalid', res.data);
            }
        } catch (e) {
            console.error('❌ Dashboard Stats Failed', e.response?.data || e.message);
        }
    }

    // 4. Test Get Profile (User)
    if (userToken) {
        try {
            const res = await axios.get(`${API_URL}/users/profile`, {
                headers: { 'x-auth-token': userToken }
            });
            if (res.data.username === 'final_user') {
                console.log('✅ Get Profile Successful');
            } else {
                console.error('❌ Get Profile Mismatch', res.data);
            }
        } catch (e) {
            console.error('❌ Get Profile Failed', e.response?.data || e.message);
        }

        // 5. Test Update Profile (User)
        try {
            const res = await axios.put(`${API_URL}/users/profile`, {
                fullname: 'Updated Final User',
                phone: '9999999999'
            }, {
                headers: { 'x-auth-token': userToken }
            });
            if (res.data.fullname === 'Updated Final User') {
                console.log('✅ Update Profile Successful');
            } else {
                console.error('❌ Update Profile Mismatch', res.data);
            }
        } catch (e) {
            console.error('❌ Update Profile Failed', e.response?.data || e.message);
        }
    }

  } catch (err) {
    console.error('Test Script Error:', err);
  } finally {
    // Cleanup
    if (mongoose.connection.readyState !== 0) {
        await User.deleteMany({ username: 'final_admin' });
        await User.deleteMany({ username: 'final_user' });
        await mongoose.disconnect();
    }
  }
}

runTests();
