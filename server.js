const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const app = express();
const UPLOAD_FOLDER = 'uploads';
const upload = multer({ dest: UPLOAD_FOLDER });

// Tworzenie folderu na pliki, jeśli nie istnieje
if (!fs.existsSync(UPLOAD_FOLDER)) {
    fs.mkdirSync(UPLOAD_FOLDER);
}

app.post('/upload', upload.single('file'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ message: 'No file uploaded' });
    }

    const filename = req.file.originalname;
    const filePath = path.join(UPLOAD_FOLDER, filename);

    // Logowanie operacji
    console.log(`Received file: ${filename}`);

    // Sprawdzanie, czy plik już istnieje
    if (fs.existsSync(filePath)) {
        console.log(`File ${filename} already exists (duplicate)`);
        return res.status(409).json({ message: `File ${filename} already exists` });
    }

    // Zapisanie pliku z oryginalną nazwą
    fs.renameSync(req.file.path, filePath);
    console.log(`File ${filename} saved successfully`);
    res.status(201).json({ message: `File ${filename} uploaded successfully` });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
