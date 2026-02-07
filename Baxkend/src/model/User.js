const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  fullname: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  gender: {
    type: String,
    required: true,
  },
  username: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
    role: {
    type: String,
    enum: ['admin', 'user'],
    default: 'user',
  },
  favorites: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Book',
  }],
  readingHistory: [{
    book: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Book',
    },
    readAt: {
        type: Date,
        default: Date.now,
    }
  }],
});

module.exports = mongoose.model('User', UserSchema);
