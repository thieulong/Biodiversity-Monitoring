const fileInput = document.getElementById('fileInput');
const fileList = document.getElementById('fileList');
const dropZone = document.getElementById('dropZone');
const uploadBtn = document.getElementById('uploadBtn');
const eraseBtn = document.getElementById('eraseBtn');
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

    if (filesToUpload.length === 0) {
        status.textContent = 'Please select at least one file to upload.';
        status.className = 'error';
        status.style.display = 'block';
        return;
    }

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
        const res = await fetch('http://localhost:3880/upload-files', {
            method: 'POST',
            body: formData
        });

        showStatus(res.ok ? 'Files uploaded successfully!' : 'Upload failed.', res.ok ? 'success' : 'error');

        fetchRowCount();

    } catch (err) {
        status.textContent = 'Error: ' + err.message;
        status.className = 'error';
        status.style.display = 'block';
    }
});

eraseBtn.addEventListener('click', async () => {
    if (!confirm('⚠️ Are you sure you want to erase ALL data? This cannot be undone.')) {
        return; // User canceled
    }

    try {
        const res = await fetch('http://localhost:3880/erase-data', {
            method: 'POST'
        });
        if (res.ok) {
            showStatus('All data has been erased.', 'success');
            fetchRowCount();
        } else {
            showStatus('Failed to erase data.', 'error');
        }
    } catch (err) {
        status.textContent = 'Error: ' + err.message;
        status.className = 'error'; // Yellow bar
    }

    status.style.display = 'block';

    // Auto-hide the notification after 5 seconds
    setTimeout(() => {
        status.style.display = 'none';
    }, 5000);
});

function showStatus(message, type) {
    status.textContent = message;
    status.className = ''; // Clear previous classes
    status.classList.add(type === 'success' ? 'success' : 'error');
    status.style.display = 'block';

    // Auto-clear after 5 seconds
    setTimeout(() => {
        status.style.display = 'none';
        status.textContent = '';
        status.className = '';
    }, 5000);
}

dropZone.addEventListener('click', () => fileInput.click());

dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('dragover');
});

dropZone.addEventListener('dragleave', () => {
    dropZone.classList.remove('dragover');
});

dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('dragover');
    fileInput.files = e.dataTransfer.files;
    fileInput.dispatchEvent(new Event('change')); // Trigger existing file handling
});

async function fetchRowCount() {
  try {
    const res = await fetch('http://localhost:3880/row-count');
    const data = await res.json();
    const countElem = document.getElementById('rowCount');

    // Fix: access the nested rowsUploaded value
    const count = data.rowsUploaded?.rowsUploaded || "0";

    if (countElem) {
      countElem.innerHTML = `<strong>Total rows uploaded:</strong> ${count}`;
    }
  } catch (err) {
    console.error('Error fetching row count:', err);
  }
}

window.addEventListener('DOMContentLoaded', fetchRowCount);

// Also update row count every 10 seconds
setInterval(fetchRowCount, 5000);
