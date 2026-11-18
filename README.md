# Cat Expression Classification CNN Accelerator on FPGA (SoC)

Repository ini berisi implementasi akselerator perangkat keras **Convolutional Neural Network (CNN)** berbasis **Verilog HDL** untuk klasifikasi 4 ekspresi wajah kucing (*Angry*, *Happy*, *Sad*, *Surprised*) pada citra grayscale beresolusi **64x64 piksel**.

## Struktur & Kegunaan Masing-Masing Folder

| Folder | Kegunaan & Isi Utama |
| :--- | :--- |
| **`dataset/`** | Menyimpan **dataset mentah asli** (960 gambar) yang terbagi ke dalam folder `train`, `valid`, dan `test` beserta file anotasi koordinat wajah kucing sebelum diproses. |
| **`dataset_64x64_bmp/`** | Menyimpan **sampel citra uji hasil preprocessing** berformat `.bmp` berukuran **64x64 piksel** (60x60 piksel wajah kucing hasil *auto-crop* + 2 piksel *blank/zero-padding* di setiap tepi) untuk pengujian pembacaan citra oleh program. |
| **`algorithm/`** | Menyimpan kode program **Python** (Jupyter Notebook / Google Colab) untuk membaca citra `.bmp`, melatih serta memvalidasi model CNN 3-blok (**akurasi testing 86.46%**), dan mengekspor bobot serta citra uji terkuantisasi 8-bit ke format `.hex`. |
| **`verilog/`** | Menyimpan kode sumber **Verilog HDL** (`CustomIP.v`, `CustomIP_Classifier.v`), *testbench* (`tb_CustomIP.v`, `tb_Accuracy.v`), serta file memori bobot dan citra uji (`.hex`) yang dikompilasi dan diverifikasi pada **ModelSim** dan **Quartus Prime** (**akurasi hardware 85.42%**). |
| **`laporan/`** | Menyimpan dokumentasi progres pengerjaan (`README.md`), grafik hasil prediksi model Python, tangkapan layar gelombang *waveform* simulasi konvolusi ModelSim, serta bukti pengujian akurasi RTL. |

## Ringkasan Perbandingan Hasil (Python vs Verilog)

- **Algoritma Software (Python FP32):** **86.46%** (83 / 96 citra uji tepat)
- **Hardware RTL (Verilog INT8 / ModelSim):** **85.42%** (82 / 96 citra uji tepat)
- **Waktu Eksekusi Konvolusi Hardware:** **153.950 ns** (~0,154 ms pada clock 50 MHz)
