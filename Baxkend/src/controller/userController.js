const User = require('../model/User');
const bcrypt = require('bcrypt');

// Get current user profile
exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password').populate('favorites');
    if (!user) return res.status(404).json({ msg: 'User not found' });
    res.json(user);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};



// Update current user profile
exports.updateProfile = async (req, res) => {
  const { fullname, phone, gender } = req.body;
  
  try {
      const userFields = {};
      if (fullname) userFields.fullname = fullname;
      if (phone) userFields.phone = phone;
      if (gender) userFields.gender = gender;

      let user = await User.findByIdAndUpdate(
          req.user.id,
          { $set: userFields },
          { new: true }
      ).select('-password');

      res.json(user);
  } catch(err) {
      console.error(err.message);
      res.status(500).send('Server Error');
  }
};

// Get all users
exports.getUsers = async (req, res) => {
  try {
    const users = await User.find().select('-password');
    res.json(users);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// Get user by ID
exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.json(user);
  } catch (err) {
    console.error(err.message);
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.status(500).send('Server Error');
  }
};

// Add a user (Admin only)
exports.addUser = async (req, res) => {
  const { fullname, phone, gender, username, password, role } = req.body;

  // Basic Validation
  if (!fullname || !username || !password) {
      return res.status(400).json({ msg: 'Please enter all required fields' });
  }

  try {
    let user = await User.findOne({ username });
    if (user) {
      return res.status(400).json({ msg: 'User already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    user = new User({
      fullname,
      phone,
      gender,
      username,
      password: hashedPassword,
      role: role || 'user',
    });

    await user.save();
    res.json({ msg: 'User created successfully', user: { username, role, fullname } });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// Update user (Admin only - e.g. update role or reset password)
exports.updateUser = async (req, res) => {
  const { fullname, phone, gender, role, password } = req.body;
  
  try {
    let user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ msg: 'User not found' });

    const userFields = {};
    if (fullname) userFields.fullname = fullname;
    if (phone) userFields.phone = phone;
    if (gender) userFields.gender = gender;
    if (role) userFields.role = role;
    if (password) {
        const salt = await bcrypt.genSalt(10);
        userFields.password = await bcrypt.hash(password, salt);
    }

    user = await User.findByIdAndUpdate(
      req.params.id,
      { $set: userFields },
      { new: true }
    ).select('-password');
    
    res.json(user);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// Delete user
exports.deleteUser = async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    res.json({ msg: 'User removed' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

// Add to favorites
// Add to favorites
exports.addFavorite = async (req, res) => {
    try {
        const { bookId } = req.body;

        if (!bookId) {
            return res.status(400).json({ error: 'Book ID is required' });
        }

        // Prevent duplicate favorites using $addToSet
        const user = await User.findByIdAndUpdate(
            req.user.id,
            { $addToSet: { favorites: bookId } },
            { new: true }
        );
        res.json({ message: 'Book added to favorites', favorites: user.favorites });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Failed to favorite book' });
    }
};

// Remove from favorites
exports.removeFavorite = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);
        const bookId = req.params.bookId;
        
        user.favorites = user.favorites.filter(id => id.toString() !== bookId);
        await user.save();
        res.json(user.favorites);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// Get favorites (Populated)
exports.getFavorites = async (req, res) => {
    try {
        const user = await User.findById(req.user.id).populate('favorites');
        res.json(user.favorites);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// Add to Reading History
exports.addToHistory = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);
        const bookId = req.params.bookId;
        
        // Remove if exists (to move to top)
        user.readingHistory = user.readingHistory.filter(item => item.book.toString() !== bookId);
        
        // Add to top
        user.readingHistory.unshift({ book: bookId });
        // Optional: Limit history size (e.g., 20)
        if (user.readingHistory.length > 20) {
            user.readingHistory = user.readingHistory.slice(0, 20);
        }
        
        await user.save();
        res.json(user.readingHistory);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// Get History (Populated)
exports.getHistory = async (req, res) => {
    try {
        const user = await User.findById(req.user.id).populate('readingHistory.book');
        res.json(user.readingHistory);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};

// Update Username
exports.updateUsername = async (req, res) => {
    try {
        const { newUsername } = req.body;
        
        // Validation
        if (!newUsername) {
            return res.status(400).json({ msg: 'Username is required' });
        }

        // Check availability
        const existing = await User.findOne({ username: newUsername });
        if (existing) {
             return res.status(400).json({ msg: 'Username already taken' });
        }

        const user = await User.findByIdAndUpdate(
            req.user.id,
            { username: newUsername },
            { new: true }
        ).select('-password');
        
        res.json({ message: 'Username updated', user });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
};
