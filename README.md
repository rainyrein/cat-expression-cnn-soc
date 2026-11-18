# Cat Expression Classification CNN Accelerator on FPGA (SoC)

Repository ini berisi rancangan dan implementasi akselerator perangkat keras **Convolutional Neural Network (CNN)** berbasis **Verilog HDL** untuk mengklasifikasikan 4 ekspresi wajah kucing (*Angry*, *Happy*, *Sad*, *Surprised*) pada citra grayscale beresolusi **64x64 piksel**, ditujukan untuk target arsitektur **Intel Cyclone V (SoC FPGA)**.

---

## 1. Struktur & Kegunaan Masing-Masing Folder

| Folder | Kegunaan & Isi Utama |
| :--- | :--- |
| **`dataset/`** | Menyimpan **dataset mentah asli** (960 gambar) yang terbagi ke dalam `train`, `valid`, dan `test` beserta anotasi koordinat wajah kucing sebelum diproses. |
| **`dataset_64x64_bmp/`** | Menyimpan **sampel citra uji hasil preprocessing** berformat `.bmp` berukuran **64x64 piksel** (60x60 piksel wajah hasil *auto-crop* + 2 piksel *blank/zero-padding* di setiap tepi) untuk pengujian pembacaan citra. |
| **`algorithm/`** | Menyimpan skrip dan *notebook* **Python** (`Untitled0.ipynb`, `preprocess_and_cnn.py`) untuk membaca citra `.bmp`, melatih model CNN, memvalidasi akurasi perangkat lunak (**86.46%**), serta mengekspor bobot dan fitur terkuantisasi ke format `.hex`. |
| **`verilog/`** | Menyimpan kode sumber **Verilog HDL** (`CustomIP.v`, `CustomIP_Classifier.v`), *testbench* (`tb_CustomIP.v`, `tb_Accuracy.v`), dan file memori (`.hex`) yang disimulasikan dan diverifikasi pada **ModelSim** dan **Quartus Prime** (**85.42%**). |
| **`laporan/`** | Menyimpan dokumentasi lengkap hasil pengujian (`README.md`) beserta tangkapan layar prediksi Python, gelombang *waveform* konvolusi ModelSim, dan bukti akurasi RTL. |

---

## 2. Alur Pengerjaan (Step-by-Step: Dataset hingga Verifikasi FPGA)

### Step 1: Pengumpulan & Preprocessing Dataset Citra (`dataset/` & `dataset_64x64_bmp/`)
- Dataset berjumlah **960 citra** wajah kucing dalam 4 kategori ekspresi (*Angry*, *Happy*, *Sad*, *Surprised*) dibagi menjadi **864 data latih** dan **96 data uji**.
- Setiap citra dipotong otomatis (*auto-crop*) berdasarkan koordinat *bounding box* wajah, dikonversi ke **grayscale 1-channel**, diubah ukurannya menjadi **60x60 piksel**, lalu ditambahkan **2 piksel *zero-padding* (blank pixel bernilai 0)** di keempat sisinya sehingga menghasilkan citra standar berukuran **64x64 piksel** berformat `.bmp`.

### Step 2: Perancangan & Pelatihan Algoritma CNN di Python (`algorithm/`)
- Skrip `preprocess_and_cnn.py` memverifikasi pembacaan struktur biner file `.bmp` 64x64 piksel dan logika inferensi CNN.
- Model CNN 3-blok dilatih menggunakan Python (`Untitled0.ipynb`) pada 864 data latih dan dievaluasi pada 96 data uji independen, mencapai **akurasi training 99.54%** dan **akurasi testing 86.46%** (83 dari 96 citra uji terklasifikasi tepat).

### Step 3: Kuantisasi Parameter Model ke Fixed-Point 8-Bit (`.hex`)
- Agar arsitektur CNN dapat berjalan efisien pada *Block RAM* dan *DSP* FPGA tanpa aritmatika *floating-point* yang berat, bobot filter konvolusi, bobot *fully-connected classifier*, bias, serta vektor fitur uji dikonversi ke format bilangan bulat bertanda **8-bit (*signed int8*)** dan **16-bit (*signed int16*)**.
- Parameter terkuantisasi diekspor ke dalam 6 file heksadesimal (`cnn_weights.hex`, `fc_weights.hex`, `fc_bias.hex`, `cat_sample_image.hex`, `test_features.hex`, `test_labels.hex`) untuk dimuat langsung oleh hardware menggunakan perintah `$readmemh`.

### Step 4: Perancangan Arsitektur RTL Hardware dalam Verilog HDL (`verilog/`)
- **`CustomIP.v`**: Mengimplementasikan unit akselerator konvolusi 2D (kernel 3x3) dengan operasi *Multiply-Accumulate* (MAC) paralel serta fungsi aktivasi **ReLU** pada citra masukan 64x64 piksel.
- **`CustomIP_Classifier.v`**: Mengimplementasikan lapisan klasifikasi akhir terkuantisasi 8-bit yang menghitung akumulasi skor untuk 4 kelas ekspresi dan memilih kelas dengan skor tertinggi.

### Step 5: Simulasi Fungsional & Validasi Akurasi di ModelSim (`laporan/`)
- **Uji Konvolusi (`tb_CustomIP.v`)**: Simulasi berjalan dengan 0 error pada clock **50 MHz** dengan total waktu eksekusi **153.950 ns** (~0,154 ms) untuk 2 filter, menghasilkan **123 piksel aktif** (aktivasi maks. 157) pada Filter 0 dan **3.783 piksel aktif** (aktivasi maks. 1.090) pada Filter 1.
- **Uji Akurasi Batch (`tb_Accuracy.v`)**: Pengujian langsung terhadap seluruh **96 sampel uji** pada level RTL menghasilkan **82 prediksi benar dari 96 citra** atau **akurasi hardware 85.42%**.

---

## 3. Perbandingan Akhir: Algoritma Python vs Hardware Verilog

| Parameter Evaluasi | Model Software (Python) | Akselerator Hardware (Verilog RTL) |
| :--- | :---: | :---: |
| **Presisi Aritmatika** | Floating-Point 32-bit (FP32) | Fixed-Point Quantized 8-bit (INT8) |
| **Total Sampel Uji** | 96 Citra (64x64 Grayscale) | 96 Citra (64x64 Grayscale) |
| **Jumlah Prediksi Benar** | 83 / 96 Citra | 82 / 96 Citra |
| **Akurasi Pengujian** | **86.46%** | **85.42%** |
| **Selisih Akurasi (*Quantization Loss*)** | - | **1.04%** |
| **Waktu Komputasi Konvolusi (50 MHz)** | - | **153.950 ns (~0,154 ms)** |
