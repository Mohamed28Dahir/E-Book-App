const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

const API_URL = 'http://localhost:3000/api';

async function testFileUpload() {
    console.log(' Testing File Upload System...\n');
    
    try {
        // 1. Login as admin
        console.log('1️⃣ Logging in as admin...');
        const login = await axios.post(`${API_URL}/auth/login`, {
            username: 'admin',
            password: 'admin123'
        });
        const adminToken = login.data.token;
        console.log('✅ Logged in successfully\n');
        
        // 2. Test POST /books without files (should work)
        console.log('2️⃣ Testing POST /books without files...');
        try {
            const bookWithoutFiles = await axios.post(`${API_URL}/books`, {
                title: 'Test Book No Files',
                author: 'Test Author',
                category: 'Story',
                description: 'Test description',
                rating: 4.5,
                pages: 200
            }, {
                headers: { 'x-auth-token': adminToken }
            });
            console.log('✅ Book created without files:', bookWithoutFiles.data._id);
            
            // Clean up
            await axios.delete(`${API_URL}/books/${bookWithoutFiles.data._id}`, {
                headers: { 'x-auth-token': adminToken }
            });
            console.log('✅ Cleaned up test book\n');
        } catch (e) {
            console.log('❌ Failed:', e.response?.data || e.message, '\n');
        }
        
        // 3. Test POST /books with FormData (simulating Flutter)
        console.log('3️⃣ Testing POST /books with FormData...');
        try {
            const formData = new FormData();
            formData.append('title', 'Test Book With FormData');
            formData.append('author', 'Test Author');
            formData.append('category', 'Education');
            formData.append('description', 'Test description with FormData');
            formData.append('rating', '4.0');
            formData.append('pages', '150');
            
            const bookWithFormData = await axios.post(`${API_URL}/books`, formData, {
                headers: {
                    'x-auth-token': adminToken,
                    ...formData.getHeaders()
                }
            });
            console.log('✅ Book created with FormData:', bookWithFormData.data._id);
            console.log('   Cover Image:', bookWithFormData.data.coverImage || 'null');
            console.log('   PDF URL:', bookWithFormData.data.pdfUrl || 'null\n');
            
            // Clean up
            await axios.delete(`${API_URL}/books/${bookWithFormData.data._id}`, {
                headers: { 'x-auth-token': adminToken }
            });
            console.log('✅ Cleaned up test book\n');
        } catch (e) {
            console.log('❌ Failed:', e.response?.data || e.message, '\n');
        }
        
        // 4. Check upload directories
        console.log('4️⃣ Checking upload directories...');
        const dirs = [
            'uploads/',
            'uploads/books',
            'uploads/books/covers',
            'uploads/books/pdfs'
        ];
        
        dirs.forEach(dir => {
            if (fs.existsSync(dir)) {
                console.log(`✅ ${dir} exists`);
            } else {
                console.log(`❌ ${dir} missing`);
            }
        });
        
        console.log('\n✨ File upload system test complete!');
        
    } catch (e) {
        console.error('❌ Critical Error:', e.message);
    }
}

testFileUpload();
