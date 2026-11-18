# Implementasi Hardware RTL (Verilog HDL & ModelSim)

Folder ini berisi seluruh kode sumber perangkat keras **Verilog HDL**, *testbench* simulasi, serta file memori heksadesimal (`.hex`) hasil kuantisasi dari model Python untuk diimplementasikan dan diverifikasi pada **ModelSim** dan **Intel Quartus Prime**.

## Penjelasan Lengkap Per File

| Nama File | Jenis | Kegunaan & Fungsi Utama |
| :--- | :---: | :--- |
| **`CustomIP.v`** | RTL Hardware | Modul utama akselerator konvolusi 2D (kernel 3x3) + fungsi aktivasi ReLU untuk citra grayscale **64x64 piksel** menggunakan operasi *Multiply-Accumulate* (MAC) paralel. |
| **`CustomIP_Classifier.v`** | RTL Hardware | Modul klasifikasi akhir terkuantisasi 8-bit (*signed int8*) yang menghitung skor 4 kelas ekspresi wajah kucing (*Angry*, *Happy*, *Sad*, *Surprised*) dan menentukan kelas prediksi tertinggi. |
| **`tb_CustomIP.v`** | Testbench | *Testbench* verifikasi fungsional `CustomIP.v` di ModelSim untuk memvalidasi gelombang *waveform* sinyal kontrol (`start`, `done`, `filter_sel`), jumlah piksel aktif ReLU, dan waktu komputasi (153.950 ns pada 50 MHz). |
| **`tb_Accuracy.v`** | Testbench | *Testbench* pengujian akurasi otomatis pada seluruh **96 citra uji** di ModelSim yang mencatatkan **82/96 prediksi tepat** (**akurasi hardware 85.42%**). |
| **`cat_sample_image.hex`** | Data Memori | Representasi heksadesimal dari 1 sampel citra uji wajah kucing berukuran **64x64 piksel** (4.096 piksel grayscale 8-bit) yang dimuat oleh `CustomIP.v` melalui `$readmemh`. |
| **`cnn_weights.hex`** | Bobot Memori | Bobot filter konvolusi 3x3 terkuantisasi *signed 8-bit* (`int8`) hasil pelatihan model CNN di Python untuk proses ekstraksi fitur pada `CustomIP.v`. |
| **`fc_weights.hex`** | Bobot Memori | Matriks bobot lapisan *fully-connected classifier* terkuantisasi *signed 8-bit* (4 kelas x 128 fitur = 512 nilai) yang digunakan `CustomIP_Classifier.v`. |
| **`fc_bias.hex`** | Bobot Memori | Nilai bias terkuantisasi *signed 16-bit* (4 nilai untuk masing-masing kelas ekspresi) pada perhitungan skor `CustomIP_Classifier.v`. |
| **`test_features.hex`** | Data Memori | Vektor fitur hasil ekstraksi CNN untuk seluruh **96 sampel uji** (96 x 128 fitur terkuantisasi 8-bit) yang diuji secara batch oleh `tb_Accuracy.v`. |
| **`test_labels.hex`** | Label Uji | Kunci jawaban label ekspresi asli (0 = *Angry*, 1 = *Happy*, 2 = *Sad*, 3 = *Surprised*) untuk 96 sampel uji sebagai pembanding penghitungan akurasi di `tb_Accuracy.v`. |
