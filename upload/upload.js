const fileInput = document.getElementById('fileInput');
const fileList = document.getElementById('fileList');
const uploadBtn = document.getElementById('uploadBtn');
const status = document.getElementById('status');

let filesToUpload = [];

fileInput.addEventListener('change', () => {
    fileList.innerHTML = '';
    filesToUpload = [];

    Array.from(fileInput.files).forEach((file, index) => {
        const div = document.createElement('div');
        div.classList.add('file-item');
        div.innerHTML = `
            <strong>${file.name}</strong>
            <input type="text" placeholder="Enter ID or description for this data" data-index="${index}">
        `;
        fileList.appendChild(div);
        filesToUpload.push({ file, id: '' });
    });
});

uploadBtn.addEventListener('click', async () => {
    document.querySelectorAll('input[data-index]').forEach(input => {
        const idx = parseInt(input.dataset.index);
        filesToUpload[idx].id = input.value.trim();
    });

    if (filesToUpload.some(f => !f.id)) {
        alert('Please assign IDs or descriptions to all files.');
        return;
    }

    const formData = new FormData();
    filesToUpload.forEach((f, i) => {
        formData.append(`file${i}`, f.file);
        formData.append(`id${i}`, f.id);
    });

    try {
        const res = await fetch('http://localhost:1880/upload-files', {
            method: 'POST',
            body: formData
        });
        status.textContent = res.ok ? 'Files uploaded successfully!' : 'Upload failed.';
    } catch (err) {
        status.textContent = 'Error: ' + err.message;
    }
});
