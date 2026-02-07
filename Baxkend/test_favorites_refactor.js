const axios = require('axios');
// Using Port 3007
const API_URL = 'http://localhost:3007/api';

async function testRefactoredFavorites() {
    try {
        console.log('🚀 Testing Refactored Favorites (POST /favorite)...');
        
        // 1. Signup/Login
        const testUser = `usr_fav_${Date.now()}`;
        console.log(`Creating user: ${testUser}`);
        
        await axios.post(`${API_URL}/auth/signup`, {
             fullname: 'Fav User',
             username: testUser,
             password: 'password123',
             phone: '1111111111',
             gender: 'Other'
        });
        
        const loginRes = await axios.post(`${API_URL}/auth/login`, {
            username: testUser,
            password: 'password123'
        });
        const token = loginRes.data.token;
        console.log('✅ Logged In');
        
        // 2. Create a Book (Need Admin)
        // Quick hack: Create admin or use existing admin creds. 
        // Or assume we have a valid Object ID. We can use a fake MongoID since schema ref check is loose on save usually unless populated.
        // Actually, User schema has ref: 'Book'. Mongoose might not check existence on save, but let's try.
        // If strict, we need a real book.
        
        // Let's create an admin first to add a book
        const adminUser = `admin_${Date.now()}`;
        await axios.post(`${API_URL}/auth/signup`, {
             fullname: 'Admin User',
             username: adminUser,
             password: 'password123',
             phone: '0000000000',
             gender: 'Male',
             role: 'admin'
        });
         const adminLogin = await axios.post(`${API_URL}/auth/login`, {
            username: adminUser,
            password: 'password123'
        });
        const adminToken = adminLogin.data.token;
        
        const bookRes = await axios.post(`${API_URL}/books`, {
            title: 'Test Book',
            author: 'Test Author',
            description: 'Desc',
            price: 10,
            category: 'Tech'
        }, { headers: { 'x-auth-token': adminToken }});
        
        const bookId = bookRes.data._id;
        console.log(`✅ Book Created: ${bookId}`);
        
        // 3. Add to Favorites (New API)
        console.log('Adding to favorites via POST /users/favorite body...');
        const favRes = await axios.post(`${API_URL}/users/favorite`, 
            { bookId: bookId },
            { headers: { 'x-auth-token': token } }
        );
        
        if (favRes.data.message === 'Book added to favorites' && favRes.data.favorites.includes(bookId)) {
            console.log('✅ Add Favorite Success');
        } else {
            console.error('❌ Add Favorite Failed', favRes.data);
        }
        
        // 4. Duplicate Check
        console.log('Testing Duplicate Prevention...');
        const dupRes = await axios.post(`${API_URL}/users/favorite`, 
            { bookId: bookId },
            { headers: { 'x-auth-token': token } }
        );
        // Should succeed but not duplicate
        if (dupRes.data.favorites.filter(id => id === bookId).length === 1) {
             console.log('✅ Duplicate Prevention Success');
        } else {
             console.error('❌ Duplicate Prevention Failed', dupRes.data.favorites);
        }
        
    } catch (e) {
        console.error('Test Failed:', e.response?.data || e.message);
    }
}

testRefactoredFavorites();
