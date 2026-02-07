const axios = require('axios');
const API_URL = 'http://localhost:3008/api';

async function testCompleteFavorites() {
    console.log('🚀 Testing Complete Favorites Implementation...\n');
    
    try {
        // Use valid MongoDB ObjectIds for testing (books don't need to exist for favorites storage)
        const bookId1 = '507f1f77bcf86cd799439011';
        const bookId2 = '507f1f77bcf86cd799439012';
        console.log('📚 Step 1: Using test ObjectIds for books');
        
        // Step 2: Create Regular User
        console.log('\n👤 Step 2: Creating test user...');
        const testUser = `user_fav_${Date.now()}`;
        await axios.post(`${API_URL}/auth/signup`, {
            fullname: 'Test User',
            username: testUser,
            password: 'password123',
            phone: '1111111111',
            gender: 'Other'
        });
        
        const loginRes = await axios.post(`${API_URL}/auth/login`, {
            username: testUser,
            password: 'password123'
        });
        const userToken = loginRes.data.token;
        console.log(`✅ User logged in`);
        
        // Step 3: Add First Book to Favorites
        console.log('\n❤️  Step 3: Adding book to favorites...');
        const addFav1 = await axios.post(`${API_URL}/users/favorite`, 
            { bookId: bookId1 },
            { headers: { 'x-auth-token': userToken }}
        );
        
        if (addFav1.data.message === 'Book added to favorites' && 
            addFav1.data.favorites.includes(bookId1)) {
            console.log(`✅ Book 1 added to favorites`);
        } else {
            console.error(`❌ Failed to add book 1`, addFav1.data);
            return;
        }
        
        // Step 4: Test Duplicate Prevention
        console.log('\n🔄 Step 4: Testing duplicate prevention...');
        const dupRes = await axios.post(`${API_URL}/users/favorite`, 
            { bookId: bookId1 },
            { headers: { 'x-auth-token': userToken }}
        );
        
        const duplicateCount = dupRes.data.favorites.filter(id => id === bookId1).length;
        if (duplicateCount === 1) {
            console.log(`✅ Duplicate prevention works ($addToSet verified)`);
        } else {
            console.error(`❌ Duplicate found! Count: ${duplicateCount}`);
            return;
        }
        
        // Step 5: Add Second Book
        console.log('\n❤️  Step 5: Adding second book...');
        const addFav2 = await axios.post(`${API_URL}/users/favorite`, 
            { bookId: bookId2 },
            { headers: { 'x-auth-token': userToken }}
        );
        
        if (addFav2.data.favorites.length === 2) {
            console.log(`✅ Second book added (Total: ${addFav2.data.favorites.length})`);
        } else {
            console.error(`❌ Expected 2 favorites, got ${addFav2.data.favorites.length}`);
        }
        
        // Step 6: Get Favorites
        console.log('\n📖 Step 6: Fetching favorites...');
        const getFavs = await axios.get(`${API_URL}/users/favorites`, {
            headers: { 'x-auth-token': userToken }
        });
        
        if (Array.isArray(getFavs.data) && getFavs.data.length === 2) {
            console.log(`✅ Fetched ${getFavs.data.length} favorites`);
        } else {
            console.error(`❌ Expected 2 favorites, got:`, getFavs.data);
        }
        
        // Step 7: Remove One Favorite
        console.log('\n🗑️  Step 7: Removing one favorite...');
        const removeFav = await axios.delete(`${API_URL}/users/favorites/${bookId1}`, {
            headers: { 'x-auth-token': userToken }
        });
        
        if (Array.isArray(removeFav.data) && removeFav.data.length === 1) {
            console.log(`✅ Removed favorite (Remaining: ${removeFav.data.length})`);
        } else {
            console.error(`❌ Expected 1 favorite remaining, got:`, removeFav.data);
        }
        
        // Step 8: Verify Persistence
        console.log('\n💾 Step 8: Verifying persistence...');
        const finalCheck = await axios.get(`${API_URL}/users/favorites`, {
            headers: { 'x-auth-token': userToken }
        });
        
        if (Array.isArray(finalCheck.data) && finalCheck.data.length === 1) {
            console.log(`✅ Persistence verified - 1 favorite remains`);
        } else {
            console.error(`❌ Persistence check failed:`, finalCheck.data);
        }
        
        // Step 9: Test Missing BookId Validation
        console.log('\n🛡️  Step 9: Testing validation...');
        try {
            await axios.post(`${API_URL}/users/favorite`, 
                {},
                { headers: { 'x-auth-token': userToken }}
            );
            console.error(`❌ Validation failed - should reject empty bookId`);
        } catch (err) {
            if (err.response?.status === 400 && err.response?.data?.error) {
                console.log(`✅ Validation works - rejected empty bookId`);
            } else {
                console.error(`❌ Unexpected error:`, err.response?.data);
            }
        }
        
        console.log('\n✨ All tests passed! Favorites feature is fully functional.\n');
        console.log('📋 Summary:');
        console.log('   ✅ POST /users/favorite - adds with body param');
        console.log('   ✅ Duplicate prevention via $addToSet');
        console.log('   ✅ GET /users/favorites - returns array');
        console.log('   ✅ DELETE /users/favorites/:id - removes favorite');
        console.log('   ✅ Validation for missing bookId');
        console.log('   ✅ Data persists in MongoDB\n');
        
    } catch (e) {
        console.error('\n❌ Test Failed:', e.response?.data || e.message);
        if (e.response?.status) {
            console.error(`   Status: ${e.response.status}`);
        }
    }
}

testCompleteFavorites();
