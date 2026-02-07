
        // Check if admin exists
        const existing = await User.findOne({ username: 'admin' });
        if (existing) {
            console.log('⚠️  Admin user already exists');
            
            // Update to ensure admin role
            existing.role = 'admin';
            await existing.save();
            console.log('✅ Updated existing user to admin role');
        } else {
            // Create new admin
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash('admin123', salt);
            
            const admin = new User({
                fullname: 'Admin User',
                username: 'admin',
                password: hashedPassword,
                phone: '0000000000',
                gender: 'Male',
                role: 'admin'
            });
            
            await admin.save();
            console.log('✅ Admin user created successfully');
            console.log('   Username: admin');
            console.log('   Password: admin123');
        }
        
        await mongoose.disconnect();
        console.log('✅ Disconnected from MongoDB');
        
    } catch (e) {
        console.error('❌ Error:', e.message);
        process.exit(1);
    }
}

createAdminUser();
