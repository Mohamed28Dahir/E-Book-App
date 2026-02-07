console.log("Script starting...");
const mongoose = require('mongoose');
const User = require('./src/model/User');
require('dotenv').config();

console.log("Modules loaded.");

async function testVerification() {
    try {
        console.log('Connecting to MongoDB...');
        await mongoose.connect(process.env.MONGO_URI);
        console.log('✅ Connected.');

        const usernameToTest = "admin";

        // Test 1: Exact match
        console.log(`\nTesting exact match for '${usernameToTest}'...`);
        let userExceptions = await User.findOne({ username: usernameToTest });
        console.log(userExceptions ? "✅ Found (Exact)" : "❌ Not Found (Exact)");

        // Test 2: Case-insensitive regex (The logic in controller)
        console.log(`\nTesting regex match for '${usernameToTest}'...`);
        const regex = new RegExp("^" + usernameToTest + "$", "i");
        let userRegex = await User.findOne({ username: { $regex: regex } });
        console.log(userRegex ? "✅ Found (Regex)" : "❌ Not Found (Regex)");

        // Test 3: Uppercase input
        const upperUser = "ADMIN";
        console.log(`\nTesting regex match for UPPERCASE input '${upperUser}'...`);
        const regexUpper = new RegExp("^" + upperUser + "$", "i");
        let userUpper = await User.findOne({ username: { $regex: regexUpper } });
        console.log(userUpper ? "✅ Found (Upper)" : "❌ Not Found (Upper)");

        // List all users to see what's in there
        console.log("\nListing all users in DB:");
        const allUsers = await User.find({}, 'username');
        console.log(allUsers);

    } catch (e) {
        console.error('❌ Error:', e);
    } finally {
        await mongoose.disconnect();
        console.log('\nDone.');
    }
}

testVerification();
