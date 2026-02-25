// Like/pass routes
const express = require('express');
const router = express.Router();
const likeController = require('../controllers/likeController');
const auth = require('../middleware/authMiddleware');


// All routes protected by JWT
router.post('/like', auth, likeController.likeUser);
router.post('/pass', auth, likeController.passUser);
router.get('/candidates', auth, likeController.getSwipeCandidates);

module.exports = router;
