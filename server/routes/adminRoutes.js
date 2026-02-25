// Admin routes
const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const auth = require('../middleware/authMiddleware');
const admin = require('../middleware/adminMiddleware');

router.get('/users', auth, admin, adminController.listUsers);
router.post('/ban-user', auth, admin, adminController.banUser);
router.get('/reports', auth, admin, adminController.viewReports);

module.exports = router;
