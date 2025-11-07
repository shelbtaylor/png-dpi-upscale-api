const express = require("express");
const fileUpload = require("express-fileupload");
const { execSync } = require("child_process");
const fs = require("fs");

const app = express();
app.use(fileUpload());

app.post("/process", async (req, res) => {
  if (!req.files || !req.files.image) {
    return res.status(400).json({ error: "No file uploaded" });
  }

  try {
    // Save file
    const inputPath = "/app/input.png";
    const outputPath = "/app/output.png";
    fs.writeFileSync(inputPath, req.files.image.data);

    // Run processing script
    execSync("bash /app/process.sh", { stdio: "inherit" });

    // Return result
    const finalImage = fs.readFileSync(outputPath);
    res.set("Content-Type", "image/png");
    res.send(finalImage);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Processing failed" });
  }
});

app.listen(3000, () => console.log("✅ running on port 3000"));
