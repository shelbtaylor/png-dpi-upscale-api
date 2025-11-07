const express = require("express");
const multer = require("multer");
const { execFile } = require("child_process");
const fs = require("fs");

const app = express();
const upload = multer({ dest: "/tmp" });
const PORT = process.env.PORT || 3000;

app.get("/", (_, res) => {
  res.send("✅ PNG DPI + (optional) Upscale API Running");
});

app.post("/process", upload.single("image"), (req, res) => {
  const input = req.file.path;
  const output = "/tmp/out.png";

  execFile("/app/process.sh", [input, output], (error) => {
    if (error) {
      console.error("❌ Processing failed:", error);
      return res.status(500).send("Processing failed");
    }

    fs.readFile(output, (err, data) => {
      if (err) {
        console.error("❌ Read failed:", err);
        return res.status(500).send("Read failed");
      }

      res.set("Content-Type", "image/png");
      res.send(data);

      fs.unlinkSync(input);
      fs.unlinkSync(output);
    });
  });
});

app.listen(PORT, () =>
  console.log(`✅ Server running on port ${PORT}`)
);
