// Profile routes
const express = require('express');
const router = express.Router();
const profileController = require('../controllers/profileController');
const auth = require('../middleware/authMiddleware');

// All routes protected by JWT
router.post('/', auth, profileController.createProfile);
router.get('/', auth, profileController.getProfile);
router.put('/', auth, profileController.updateProfile);
router.delete('/', auth, profileController.deleteProfile);

module.exports = router;
