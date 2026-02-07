const User = require('../model/User');
const Book = require('../model/Book');

exports.getStats = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalBooks = await Book.countDocuments();
    // We can simulate 'Active Sessions' or just return available data.
    
    res.json({
        totalUsers,
        totalBooks,
        totalReads: 0, 
        newSubs: 0     
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
};
