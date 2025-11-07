const express = require("express");
const multer = require("multer");
const { execFile } = require("child_process");
const fs = require("fs");

const app = express();
const upload = multer({ dest: "/tmp" });

// ✅ HEALTH CHECK
app.get("/", (req, res) => {
  res.send("PNG Upscale + 300 DPI API ✅ Running");
});

app.post("/process", upload.single("image"), (req, res) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded");
  }

  const input = req.file.path;
  const output = "/tmp/out.png";

  execFile("/app/process.sh", [input, output], (error) => {
    if (error) {
      console.error("❌ Processing failed:", error);
      return res.status(500).send("Processing failed");
    }

    fs.readFile(output, (err, data) => {
      if (err) {
        console.error("❌ Could not read output:", err);
        return res.status(500).send("Read failed");
      }

      res.set("Content-Type", "image/png");
      res.send(data);

      // cleanup
      fs.unlink(input, () => {});
      fs.unlink(output, () => {});
    });
  });
});

// ✅ Required for Railway
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});
