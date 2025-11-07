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
  try {
    if (!req.file) {
      console.error("❌ No file received");
      return res.status(400).send("No file received");
    }

    const inputFile = req.file.path;
    const outputFile = "/tmp/out.png";

    console.log("✅ Received file at:", inputFile);

    execFile("/app/process.sh", [inputFile, outputFile], (error) => {
      if (error) {
        console.error("❌ Processing failed:", error);
        return res.status(500).send("Processing failed");
      }

      fs.readFile(outputFile, (err, data) => {
        if (err) {
          console.error("❌ Read failed:", err);
          return res.status(500).send("Read failed");
        }

        res.set("Content-Type", "image/png");
        res.send(data);

        fs.unlinkSync(inputFile);
        fs.unlinkSync(outputFile);
      });
    });

  } catch (e) {
    console.error("❌ Unexpected:", e);
    return res.status(500).send("Unexpected server error");
  }
});

app.listen(PORT, () => console.log("Server running on port " + PORT));
