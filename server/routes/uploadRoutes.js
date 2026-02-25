// Image upload routes
const express = require('express');
const router = express.Router();
const uploadController = require('../controllers/uploadController');
const auth = require('../middleware/authMiddleware');
const multer = require('multer');

const storage = multer.memoryStorage();
const upload = multer({ storage });

// Protected image upload endpoint
router.post('/image', auth, upload.single('image'), uploadController.uploadImage);

module.exports = router;
