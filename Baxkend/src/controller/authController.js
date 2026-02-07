const User = require('../model/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.signup = async (req, res) => {
  const { fullname, phone, gender, username, password } = req.body;

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
      role: 'user', // Default role
    });

    await user.save();

    const payload = {
      user: {
        id: user.id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '5d' },
      (err, token) => {
        if (err) throw err;
        res.json({ token, role: user.role });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    let user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Invalid Credentials' });
    }

    const payload = {
      user: {
        id: user.id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '5d' },
      (err, token) => {
        if (err) throw err;
        res.json({ token, role: user.role, username: user.username, fullname: user.fullname });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

exports.forgotPassword = async (req, res) => {
  let { username, newPassword } = req.body;

  try {
    if (!username) return res.status(400).json({ msg: 'Username is required' });
    username = username.trim();

    let user = await User.findOne({
      username: { $regex: new RegExp("^" + username + "$", "i") }
    });

    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);

    await user.save();

    res.json({ msg: 'Password updated successfully' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};

exports.verifyUsername = async (req, res) => {
  let { username } = req.body;

  try {
    if (!username) return res.status(400).json({ msg: 'Username is required' });

    username = username.trim();

    // Case-insensitive search
    let user = await User.findOne({
      username: { $regex: new RegExp("^" + username + "$", "i") }
    });

    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    res.json({ msg: 'User exists' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};
