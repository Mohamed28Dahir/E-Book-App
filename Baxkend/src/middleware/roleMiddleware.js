module.exports = function (roles) {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      console.log(`Access denied for ${req.originalUrl}. User role: ${req.user.role}, Required: ${roles}`);
      return res.status(403).json({ msg: 'Access denied: Insufficient permissions' });
    }
    next();
  };
};
