# Dataset Mentah Ekspresi Wajah Kucing (960 Citra)

Folder ini berisi **dataset mentah asli** ekspresi wajah kucing yang terdiri dari 4 kelas ekspresi: **Angry**, **Happy**, **Sad**, dan **Surprised**.

## Struktur & Kegunaan File

- **`train/`**, **`valid/`**, **`test/`**: Pembagian data citra mentah beserta file label anotasi koordinat *bounding box* wajah kucing.
- **`data.yaml`**: Konfigurasi daftar nama kelas ekspresi dan path dataset.
- **`README.dataset.txt` & `README.roboflow.txt`**: Informasi sumber dan metadata lisensi dataset.

Sebelum diproses oleh model CNN dan Verilog, citra pada folder ini dipotong otomatis berdasarkan koordinat wajah menjadi **60x60 piksel grayscale**, lalu ditambahkan 2 piksel *zero-padding* di sekeliling tepinya menjadi **64x64 piksel** (hasil sampelnya tersimpan pada folder `dataset_64x64_bmp/`).
