// Admin middleware (simple version: check admin UIDs from env or config)
const adminUIDs = (process.env.ADMIN_UIDS || '').split(',');

module.exports = (req, res, next) => {
  if (adminUIDs.includes(req.user.uid)) return next();
  return res.status(403).json({ error: 'Admin access required' });
};
