// Redis client configuration
// Uses ioredis for robust Redis support
// Reads Redis URL from environment variable or defaults to localhost

const Redis = require('ioredis');

const redis = new Redis(process.env.REDIS_URL || 'redis://localhost:6379');

module.exports = redis;
