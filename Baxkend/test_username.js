const axios = require('axios');
const API_URL = 'http://localhost:3006/api';

async function testUpdateUsername() {
    try {
        console.log('🚀 Testing Update Username...');
        
        // 1. Signup/Login
        const testUser = `usr_edit_${Date.now()}`;
        console.log(`Creating user: ${testUser}`);
        
        await axios.post(`${API_URL}/auth/signup`, {
             fullname: 'Edit User',
             username: testUser,
             password: 'password123',
             phone: '9999999999',
             gender: 'Other'
        });
        
        const loginRes = await axios.post(`${API_URL}/auth/login`, {
            username: testUser,
            password: 'password123'
        });
        const token = loginRes.data.token;
        console.log('✅ Logged In');
        
        // 2. Update Username
        const newUsername = `${testUser}_updated`;
        console.log(`Updating username to: ${newUsername}`);
        
        const updateRes = await axios.put(`${API_URL}/users/update-username`, 
            { newUsername: newUsername },
            { headers: { 'x-auth-token': token } }
        );
        
        if (updateRes.data.user.username === newUsername) {
            console.log('✅ Username Update Success (Response match)');
        } else {
            console.error('❌ Response did not match new username', updateRes.data);
        }
        
        // 3. Verify Login with New Username
        console.log('Verifying login with new username...');
        try {
            await axios.post(`${API_URL}/auth/login`, {
                username: newUsername,
                password: 'password123'
            });
            console.log('✅ Re-login Success');
        } catch (e) {
            console.error('❌ Re-login Failed');
        }
        
    } catch (e) {
        console.error('Test Failed:', e.response?.data || e.message);
    }
}

testUpdateUsername();
