# Cat Expression Classification CNN Accelerator on FPGA (SoC)

Repository ini berisi implementasi akselerator perangkat keras **Convolutional Neural Network (CNN)** berbasis **Verilog HDL** untuk klasifikasi 4 ekspresi wajah kucing (*Angry*, *Happy*, *Sad*, *Surprised*) pada citra grayscale beresolusi **64x64 piksel**.

## Perbandingan Akurasi: Algoritma Python vs Hardware Verilog

| Tahap Implementasi | Metode / Presisi Data | Sampel Uji | Jumlah Benar | Akurasi |
| :--- | :--- | :---: | :---: | :---: |
| **Algoritma Software (Python)** | Floating-Point 32-bit (FP32) | 96 Citra | 83 / 96 | **86.46%** |
| **Hardware RTL (Verilog / ModelSim)** | Fixed-Point Quantized 8-bit (INT8) | 96 Citra | 82 / 96 | **85.42%** |

Selisih antara model perangkat lunak (Python) dan simulasi perangkat keras (Verilog) hanya sebesar **1.04%** akibat kuantisasi bobot ke bilangan bulat 8-bit, membuktikan bahwa arsitektur hardware mempertahankan akurasi tinggi secara *real-time*.

## Struktur Repository

- **`dataset/`**: Berisi dataset citra ekspresi wajah kucing (960 gambar) beserta sampel citra `.bmp` berukuran 64x64 piksel (60x60 piksel wajah hasil *auto-crop* + 2 piksel *zero-padding* di sekeliling tepi).
- **`algorithm/`**: Berisi kode program **Python** (Google Colab / Jupyter Notebook) untuk *preprocessing* citra, pelatihan model CNN, visualisasi deteksi ekspresi, serta kuantisasi bobot 8-bit ke format `.hex`.
- **`verilog/`**: Berisi kode **Verilog HDL** dan file memori `.hex` yang dikompilasi dan disimulasikan menggunakan **ModelSim** dan **Intel Quartus Prime**:
  - `CustomIP.v` & `tb_CustomIP.v`: Modul akselerator konvolusi 2D (kernel 3x3) + ReLU dan *testbench*-nya.
  - `CustomIP_Classifier.v` & `tb_Accuracy.v`: Modul klasifikasi terkuantisasi 8-bit dan *testbench* pengujian akurasi pada 96 citra uji.
  - `cnn_weights.hex`, `cat_sample_image.hex`, `fc_weights.hex`, `fc_bias.hex`, `test_features.hex`, `test_labels.hex`: Data bobot dan citra uji terkuantisasi.
- **`laporan/`**: Berisi dokumentasi progres pengerjaan dan bukti visual:
  - `hasil_deteksi_ekspresi.png`: Visualisasi prediksi model CNN Python.
  - `simulasi_konvolusi_modelsim.png`: Hasil gelombang *waveform* operasi konvolusi 2D + ReLU di ModelSim.
  - `akurasi_verilog_modelsim.png`: Bukti pencapaian akurasi **85.42%** pada simulasi ModelSim.

## Alur Pengerjaan (Step-by-Step)

1. **Preprocessing Citra (Python)**: Wajah kucing dipotong otomatis berdasarkan koordinat label, diubah ke grayscale 60x60 piksel, ditambah 2 piksel *zero-padding* menjadi **64x64 piksel**, dan diekspor ke format `.bmp` serta `.hex`.
2. **Pelatihan & Validasi CNN (Python)**: Model CNN 3-blok dilatih pada 864 data latih dan diuji pada 96 data uji independen dengan hasil **akurasi training 99.54%** dan **akurasi testing 86.46%**.
3. **Kuantisasi Bobot ke Hardware**: Bobot filter konvolusi dan parameter *classifier* dikuantisasi ke format *signed 8-bit* (`.hex`) agar dapat dibaca langsung oleh *Block RAM* FPGA menggunakan `$readmemh`.
4. **Simulasi & Verifikasi RTL (ModelSim)**:
   - Akselerator konvolusi `CustomIP.v` menyelesaikan komputasi 2 filter dalam **153.950 ns** (~0,154 ms pada clock 50 MHz) dengan 123 piksel aktif (Filter 0) dan 3.783 piksel aktif (Filter 1).
   - Pengujian klasifikasi pada seluruh 96 sampel uji di `tb_Accuracy.v` menghasilkan **82/96 prediksi tepat** atau **akurasi 85.42%**.
