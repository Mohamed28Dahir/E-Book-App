const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

const API_URL = 'http://localhost:3000/api';

let testResults = {
    passed: [],
    failed: [],
    errors: []
};

function logResult(test, status, details = '') {
    const result = { test, status, details };
    if (status === 'PASS') {
        testResults.passed.push(result);
        console.log(`✅ ${test}`);
    } else if (status === 'FAIL') {
        testResults.failed.push(result);
        console.log(`❌ ${test} - ${details}`);
    } else {
        testResults.errors.push(result);
        console.log(`⚠️  ${test} - ${details}`);
    }
}

async function testAllEndpoints() {
    console.log('🚀 Starting Comprehensive Backend Diagnostic...\n');
    
    let userToken, adminToken, testBookId, testUserId;
    
    try {
        // ============ AUTH ENDPOINTS ============
        console.log('\n📝 Testing AUTH Endpoints...');
        
        // 1. Signup (Regular User)
        try {
            const userSignup = await axios.post(`${API_URL}/auth/signup`, {
                fullname: 'Test User',
                username: `testuser_${Date.now()}`,
                password: 'password123',
                phone: '1234567890',
                gender: 'Other'
            });
            userToken = userSignup.data.token;
            logResult('POST /auth/signup (User)', 'PASS');
        } catch (e) {
            logResult('POST /auth/signup (User)', 'FAIL', e.response?.data?.msg || e.message);
        }
        
        // 2. Login
        try {
            const login = await axios.post(`${API_URL}/auth/login`, {
                username: 'admin',
                password: 'admin123'
            });
            adminToken = login.data.token;
            logResult('POST /auth/login (Admin)', 'PASS');
        } catch (e) {
            logResult('POST /auth/login (Admin)', 'ERROR', 'Admin credentials may not exist');
            // Try creating admin user
            try {
                const adminSignup = await axios.post(`${API_URL}/auth/signup`, {
                    fullname: 'Admin User',
                    username: 'admin',
                    password: 'admin123',
                    phone: '0000000000',
                    gender: 'Male'
                });
                adminToken = adminSignup.data.token;
                logResult('POST /auth/signup (Admin)', 'PASS');
            } catch (e2) {
                logResult('POST /auth/signup (Admin)', 'FAIL', e2.response?.data?.msg || e2.message);
            }
        }
        
        // 3. Forgot Password
        try {
            await axios.post(`${API_URL}/auth/forgot-password`, {
                username: 'testuser',
                newPassword: 'newpass123'
            });
            logResult('POST /auth/forgot-password', 'PASS');
        } catch (e) {
            if (e.response?.status === 404) {
                logResult('POST /auth/forgot-password', 'PASS', 'User not found (expected)');
            } else {
                logResult('POST /auth/forgot-password', 'FAIL', e.response?.data?.msg || e.message);
            }
        }
        
        // ============ BOOK ENDPOINTS ============
        console.log('\n📚 Testing BOOK Endpoints...');
        
        // 4. Get All Books (Public)
        try {
            const books = await axios.get(`${API_URL}/books`);
            logResult('GET /books', 'PASS', `Found ${books.data.length} books`);
        } catch (e) {
            logResult('GET /books', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
        }
        
        // 5. Add Book (Admin Only)
        if (adminToken) {
            try {
                const bookData = {
                    title: 'Test Book',
                    author: 'Test Author',
                    category: 'Story',
                    description: 'Test Description',
                    rating: 4.5,
                    pages: 200
                };
                const newBook = await axios.post(`${API_URL}/books`, bookData, {
                    headers: { 'x-auth-token': adminToken }
                });
                testBookId = newBook.data._id;
                logResult('POST /books (Admin)', 'PASS');
            } catch (e) {
                logResult('POST /books (Admin)', 'FAIL', e.response?.status + ': ' + (e.response?.data?.msg || e.message));
            }
        }
        
        // 6. Get Book by ID
        if (testBookId) {
            try {
                await axios.get(`${API_URL}/books/${testBookId}`);
                logResult('GET /books/:id', 'PASS');
            } catch (e) {
                logResult('GET /books/:id', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 7. Update Book (Admin Only)
        if (adminToken && testBookId) {
            try {
                await axios.put(`${API_URL}/books/${testBookId}`, {
                    title: 'Updated Test Book'
                }, {
                    headers: { 'x-auth-token': adminToken }
                });
                logResult('PUT /books/:id (Admin)', 'PASS');
            } catch (e) {
                logResult('PUT /books/:id (Admin)', 'FAIL', e.response?.status + ': ' + (e.response?.data?.msg || e.message));
            }
        }
        
        // ============ USER PROFILE ENDPOINTS ============
        console.log('\n👤 Testing USER PROFILE Endpoints...');
        
        // 8. Get Profile
        if (userToken) {
            try {
                await axios.get(`${API_URL}/users/profile`, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('GET /users/profile', 'PASS');
            } catch (e) {
                logResult('GET /users/profile', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 9. Update Profile
        if (userToken) {
            try {
                await axios.put(`${API_URL}/users/profile`, {
                    fullname: 'Updated Name',
                    phone: '9876543210'
                }, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('PUT /users/profile', 'PASS');
            } catch (e) {
                logResult('PUT /users/profile', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 10. Update Username
        if (userToken) {
            try {
                await axios.put(`${API_URL}/users/update-username`, {
                    newUsername: `updated_${Date.now()}`
                }, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('PUT /users/update-username', 'PASS');
            } catch (e) {
                logResult('PUT /users/update-username', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // ============ FAVORITES & HISTORY ============
        console.log('\n❤️  Testing FAVORITES & HISTORY Endpoints...');
        
        // 11. Add to Favorites
        if (userToken && testBookId) {
            try {
                await axios.post(`${API_URL}/users/favorite`, {
                    bookId: testBookId
                }, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('POST /users/favorite', 'PASS');
            } catch (e) {
                logResult('POST /users/favorite', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 12. Get Favorites
        if (userToken) {
            try {
                await axios.get(`${API_URL}/users/favorites`, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('GET /users/favorites', 'PASS');
            } catch (e) {
                logResult('GET /users/favorites', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 13. Add to History
        if (userToken && testBookId) {
            try {
                await axios.post(`${API_URL}/users/history/${testBookId}`, {}, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('POST /users/history/:bookId', 'PASS');
            } catch (e) {
                logResult('POST /users/history/:bookId', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 14. Get History
        if (userToken) {
            try {
                await axios.get(`${API_URL}/users/history`, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('GET /users/history', 'PASS');
            } catch (e) {
                logResult('GET /users/history', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // 15. Remove from Favorites
        if (userToken && testBookId) {
            try {
                await axios.delete(`${API_URL}/users/favorites/${testBookId}`, {
                    headers: { 'x-auth-token': userToken }
                });
                logResult('DELETE /users/favorites/:bookId', 'PASS');
            } catch (e) {
                logResult('DELETE /users/favorites/:bookId', 'FAIL', e.response?.status + ': ' + (e.response?.data || e.message));
            }
        }
        
        // ============ ADMIN USER MANAGEMENT ============
        console.log('\n🔐 Testing ADMIN USER MANAGEMENT Endpoints...');
        
        // 16. Get All Users (Admin Only)
        if (adminToken) {
            try {
                await axios.get(`${API_URL}/users`, {
                    headers: { 'x-auth-token': adminToken }
                });
                logResult('GET /users (Admin)', 'PASS');
            } catch (e) {
                logResult('GET /users (Admin)', 'FAIL', e.response?.status + ': ' + (e.response?.data?.msg || e.message));
            }
        }
        
        // 17. Add User (Admin Only)
        if (adminToken) {
            try {
                const newUser = await axios.post(`${API_URL}/users`, {
                    fullname: 'Admin Created User',
                    username: `adminuser_${Date.now()}`,
                    password: 'password123',
                    phone: '1111111111',
                    gender: 'Other',
                    role: 'user'
                }, {
                    headers: { 'x-auth-token': adminToken }
                });
                testUserId = newUser.data.user?.username; // May need to fetch ID differently
                logResult('POST /users (Admin)', 'PASS');
            } catch (e) {
                logResult('POST /users (Admin)', 'FAIL', e.response?.status + ': ' + (e.response?.data?.msg || e.message));
            }
        }
        
        // ============ DASHBOARD ============
        console.log('\n📊 Testing DASHBOARD Endpoints...');
        
        // 18. Get Dashboard Stats (Admin Only)
        if (adminToken) {
            try {
                await axios.get(`${API_URL}/dashboard/stats`, {
                    headers: { 'x-auth-token': adminToken }
                });
                logResult('GET /dashboard/stats (Admin)', 'PASS');
            } catch (e) {
                logResult('GET /dashboard/stats (Admin)', 'FAIL', e.response?.status + ': ' + (e.response?.data?.msg || e.message));
            }
        }
        
        // ============ CLEANUP ============
        console.log('\n🧹 Cleanup...');
        
        // Delete Test Book
        if (adminToken && testBookId) {
            try {
                await axios.delete(`${API_URL}/books/${testBookId}`, {
                    headers: { 'x-auth-token': adminToken }
                });
                logResult('DELETE /books/:id (Cleanup)', 'PASS');
            } catch (e) {
                logResult('DELETE /books/:id (Cleanup)', 'ERROR', e.message);
            }
        }
        
    } catch (e) {
        console.error('\n❌ Critical Error:', e.message);
    }
    
    // ============ SUMMARY ============
    console.log('\n' + '='.repeat(60));
    console.log('📋 TEST SUMMARY');
    console.log('='.repeat(60));
    console.log(`✅ Passed: ${testResults.passed.length}`);
    console.log(`❌ Failed: ${testResults.failed.length}`);
    console.log(`⚠️  Errors: ${testResults.errors.length}`);
    console.log('='.repeat(60));
    
    if (testResults.failed.length > 0) {
        console.log('\n❌ FAILED TESTS:');
        testResults.failed.forEach(r => console.log(`   - ${r.test}: ${r.details}`));
    }
    
    if (testResults.errors.length > 0) {
        console.log('\n⚠️  ERROR TESTS:');
        testResults.errors.forEach(r => console.log(`   - ${r.test}: ${r.details}`));
    }
    
    console.log('\n');
}

testAllEndpoints();
