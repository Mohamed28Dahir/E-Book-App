const express = require('express');
const app = express();

// Test route loading
console.log('Testing route loading...\n');

try {
    const authRouter = require('./src/router/authRouter');
    console.log('✅ authRouter loaded');
    app.use('/api/auth', authRouter);
} catch (e) {
    console.log('❌ authRouter failed:', e.message);
}

try {
    const bookRouter = require('./src/router/bookRouter');
    console.log('✅ bookRouter loaded');
    app.use('/api/books', bookRouter);
} catch (e) {
    console.log('❌ bookRouter failed:', e.message);
}

try {
    const userRouter = require('./src/router/userRouter');
    console.log('✅ userRouter loaded');
    app.use('/api/users', userRouter);
} catch (e) {
    console.log('❌ userRouter failed:', e.message);
}

try {
    const dashboardRouter = require('./src/router/dashboardRouter');
    console.log('✅ dashboardRouter loaded');
    app.use('/api/dashboard', dashboardRouter);
} catch (e) {
    console.log('❌ dashboardRouter failed:', e.message);
}

console.log('\nRegistered routes:');
app._router.stack.forEach((r) => {
    if (r.route) {
        console.log(`  ${Object.keys(r.route.methods)[0].toUpperCase()} ${r.route.path}`);
    } else if (r.name === 'router') {
        console.log(`  ROUTER mounted at: ${r.regexp}`);
    }
});
