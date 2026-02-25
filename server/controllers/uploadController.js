// Image upload controller for Firebase Storage
const admin = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

exports.uploadImage = async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'No file uploaded' });
    const bucket = admin.storage().bucket();
    const fileName = `images/${uuidv4()}_${req.file.originalname}`;
    const file = bucket.file(fileName);
    await file.save(req.file.buffer, {
      metadata: {
        contentType: req.file.mimetype,
        metadata: { firebaseStorageDownloadTokens: uuidv4() }
      }
    });
    const publicUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(fileName)}?alt=media`;
    res.json({ imageUrl: publicUrl });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
