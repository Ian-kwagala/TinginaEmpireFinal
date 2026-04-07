// 1. IMPORTS & CONFIGURATION
const cloudinary = require("cloudinary").v2;
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const express = require("express");
const cors = require("cors");
const path = require("path");
const multer = require("multer");
const musicMetadata = require("music-metadata");
const bcrypt = require("bcrypt");
const ffmpeg = require("fluent-ffmpeg");

// Configure Cloudinary using Environment Variables
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Import database functions
const {
  setupDatabase,
  getArtists,
  addArtist,
  updateArtist,
  deleteArtist,
  getSongs,
  addSong,
  updateSong,
  deleteSong,
  toggleSongLike,
  getStats,
  getChartData,
  getSubmissions,
  addSubmission,
  markSubmissionAsRead,
  findUserByEmail,
  registerUser,
  getBandMembers,
  addBandMember,
  deleteBandMember,
  updateBandMember,
  getVideos,
  addVideo,
  deleteVideo,
  incrementVideoViewCount,
  getUsers,
  getUserDetails,
  updateUser,
  deleteUser,
} = require("./database.js");

const app = express();
const port = process.env.PORT || 3000; // Render dynamic port

// 2. MIDDLEWARE
app.use(cors());
app.use(express.json());
// Static folder kept for backward compatibility, but won't be used for new uploads
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Serve frontend files from project root
app.use(express.static(path.join(__dirname)));

// Root route -> index.html
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

// 3. CLOUDINARY STORAGE SETUP
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: async (req, file) => {
    return {
      folder: "tingina_empire",
      resource_type: "auto", // Allows images, audio, and video
      public_id: Date.now() + "-" + file.originalname.split(".")[0],
    };
  },
});
const upload = multer({ storage: storage });

// 4. API ENDPOINTS

// --- AUTH API ---
app.post("/api/auth/register", async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password)
      return res.status(400).json({ error: "All fields are required." });
    res.status(201).json(await registerUser(username, email, password));
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
app.post("/api/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await findUserByEmail(email);
    if (!user)
      return res.status(401).json({ error: "Invalid email or password." });
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch)
      return res.status(401).json({ error: "Invalid email or password." });
    const { password_hash, ...userWithoutPassword } = user;
    res.json(userWithoutPassword);
  } catch (error) {
    res.status(500).json({ error: "Server error during login." });
  }
});

// --- ARTISTS API ---
app.get("/api/artists", async (req, res) => {
  try {
    res.json(await getArtists());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post("/api/artists", upload.single("image"), async (req, res) => {
  try {
    const { name, bio, twitter_url, instagram_url, facebook_url } = req.body;
    if (!req.file) return res.status(400).json({ error: "Image is required." });
    const imageUrl = req.file.path; // Cloudinary URL
    const urls = {
      twitter: twitter_url,
      instagram: instagram_url,
      facebook: facebook_url,
    };
    res.status(201).json(await addArtist(name, bio, imageUrl, urls));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put("/api/artists/:id", upload.single("image"), async (req, res) => {
  try {
    const { name, bio, twitter_url, instagram_url, facebook_url } = req.body;
    const newImageUrl = req.file ? req.file.path : null;
    const urls = {
      twitter: twitter_url,
      instagram: instagram_url,
      facebook: facebook_url,
    };
    res.json(await updateArtist(req.params.id, name, bio, newImageUrl, urls));
  } catch (e) {
    res.status(500).json({ error: "Failed to update artist." });
  }
});

app.delete("/api/artists/:id", async (req, res) => {
  try {
    await deleteArtist(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- SONGS API ---
app.get("/api/songs", async (req, res) => {
  try {
    res.json(await getSongs());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post(
  "/api/songs",
  upload.fields([
    { name: "artwork", maxCount: 1 },
    { name: "audio", maxCount: 1 },
  ]),
  async (req, res) => {
    try {
      const { title, artistId, genre, videoUrl } = req.body;
      const artworkUrl = req.files.artwork[0].path;
      const audioUrl = req.files.audio[0].path;

      // Use parseHttp for Cloudinary URLs to get duration
      const metadata = await musicMetadata.parseHttp(audioUrl);
      const duration = Math.round(metadata.format.duration) || 0;

      res
        .status(201)
        .json(
          await addSong(
            title,
            artistId,
            artworkUrl,
            audioUrl,
            duration,
            genre,
            videoUrl,
          ),
        );
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  },
);

app.put("/api/songs/:id", async (req, res) => {
  try {
    res.json(await updateSong(req.params.id, req.body));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.delete("/api/songs/:id", async (req, res) => {
  try {
    await deleteSong(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.post("/api/songs/:id/toggle-like", async (req, res) => {
  try {
    const { increment } = req.body;
    res.json(await toggleSongLike(req.params.id, increment));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- BAND MEMBERS API ---
app.get("/api/band-members", async (req, res) => {
  try {
    res.json(await getBandMembers());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post("/api/band-members", upload.single("image"), async (req, res) => {
  try {
    const { name, role, bio } = req.body;
    const imageUrl = req.file ? req.file.path : null;
    res.status(201).json(await addBandMember(name, role, bio, imageUrl));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put("/api/band-members/:id", upload.single("image"), async (req, res) => {
  try {
    const { name, role, bio } = req.body;
    let newImageUrl = req.file ? req.file.path : null;
    res.json(
      await updateBandMember(req.params.id, name, role, bio, newImageUrl),
    );
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.delete("/api/band-members/:id", async (req, res) => {
  try {
    await deleteBandMember(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- VIDEOS API ---
app.get("/api/videos", async (req, res) => {
  try {
    res.json(await getVideos());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.post("/api/videos", upload.single("videoFile"), async (req, res) => {
  try {
    const { title, youtubeUrl, featured } = req.body;
    let localUrl = req.file ? req.file.path : null;
    let duration = 0;

    if (!title || (!localUrl && !youtubeUrl)) {
      return res
        .status(400)
        .json({
          error: "Title and either a video file or YouTube URL is required.",
        });
    }

    const videoData = { youtubeUrl, localUrl, duration, featured: !!featured };
    const newVideo = await addVideo(title, videoData);
    res.status(201).json(newVideo);
  } catch (e) {
    res.status(500).json({ error: "Failed to save video. " + e.message });
  }
});

app.post("/api/videos/:id/view", async (req, res) => {
  try {
    await incrementVideoViewCount(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- FORMS & STATS API ---
app.post("/api/submit-form", async (req, res) => {
  try {
    const { formType, name, email, ...details } = req.body;
    res.status(201).json(await addSubmission(formType, name, email, details));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.get("/api/submissions", async (req, res) => {
  try {
    res.json(await getSubmissions());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.post("/api/submissions/:id/read", async (req, res) => {
  try {
    await markSubmissionAsRead(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.get("/api/stats", async (req, res) => {
  try {
    res.json(await getStats());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.get("/api/stats/chart-data", async (req, res) => {
  try {
    res.json(await getChartData());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- USERS API ---
app.get("/api/users", async (req, res) => {
  try {
    res.json(await getUsers());
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.get("/api/users/:id/details", async (req, res) => {
  try {
    const details = await getUserDetails(req.params.id);
    if (!details) return res.status(404).json({ error: "User not found" });
    res.json(details);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.put("/api/users/:id", async (req, res) => {
  try {
    res.json(await updateUser(req.params.id, req.body));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
app.delete("/api/users/:id", async (req, res) => {
  try {
    await deleteUser(req.params.id);
    res.status(204).send();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// --- START SERVER ---
const startServer = async () => {
  try {
    await setupDatabase();
    app.listen(port, () =>
      console.log(`Backend server running on port ${port}`),
    );
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
};

startServer();
