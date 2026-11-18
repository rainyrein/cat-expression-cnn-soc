# Cat Expression Classification CNN Accelerator on FPGA (SoC)

Repository ini berisi implementasi akselerator perangkat keras **Convolutional Neural Network (CNN)** berbasis **Verilog HDL** untuk klasifikasi 4 ekspresi wajah kucing (*Angry*, *Happy*, *Sad*, *Surprised*) pada citra grayscale beresolusi **64x64 piksel**.

## Struktur Repository

- **`dataset/`**: Berisi dataset citra ekspresi wajah kucing (960 gambar) beserta sampel citra `.bmp` berukuran 64x64 piksel (60x60 piksel wajah hasil *auto-crop* + 2 piksel *zero-padding* di sekeliling tepi).
- **`algorithm/`**: Berisi kode program **Python** (Google Colab / Jupyter Notebook) untuk *preprocessing* citra, pelatihan model CNN, visualisasi deteksi ekspresi, serta kuantisasi bobot 8-bit ke format `.hex`.
- **`verilog/`**: Berisi kode **Verilog HDL** yang dikompilasi dan disimulasikan menggunakan **ModelSim** dan **Intel Quartus Prime**:
  - `CustomIP.v`: Modul akselerator konvolusi 2D (kernel 3x3) + fungsi aktivasi ReLU.
  - `tb_CustomIP.v`: *Testbench* untuk verifikasi fungsional di ModelSim.
  - `cnn_weights.hex`: Bobot terkuantisasi 8-bit hasil pelatihan Python.
  - `cat_sample_image.hex`: Sampel citra uji 64x64 piksel dalam format heksadesimal.
- **`laporan/`**: Berisi dokumentasi progres pengerjaan, grafik akurasi model Python, tangkapan layar gelombang simulasi ModelSim, dan ringkasan sintesis FPGA.

## Alur Pengerjaan (Step-by-Step: Python ke Verilog)

1. **Preprocessing & Pembacaan Citra (Python)**: Citra wajah kucing dipotong otomatis berdasarkan koordinat bounding box, diubah menjadi grayscale 60x60 piksel, ditambahkan 2 piksel *blank/zero-padding* menjadi **64x64 piksel**, serta diekspor ke format `.bmp` dan `.hex`.
2. **Pelatihan & Validasi Algoritma CNN (Python)**: Model CNN 3-blok dilatih menggunakan 864 data latih dan diuji pada 96 data uji independen dengan capaian **akurasi testing 86.46%** dan **akurasi training 99.54%**.
3. **Kuantisasi Bobot ke Hardware**: Bobot filter konvolusi pertama dikonversi menjadi bilangan bulat bertanda 8-bit (*signed int8*) ke dalam `cnn_weights.hex` agar dapat langsung dibaca oleh *Block RAM* FPGA melalui `$readmemh`.
4. **Implementasi & Verifikasi RTL (Verilog / ModelSim)**: Modul `CustomIP.v` mengeksekusi operasi *Multiply-Accumulate* (MAC) 3x3 paralel dan ReLU secara identik dengan lapisan konvolusi pada Python:
   - **Filter 0**: Menghasilkan **123 piksel aktif (ReLU > 0)** dengan nilai aktivasi maksimum **157**.
   - **Filter 1**: Menghasilkan **3.783 piksel aktif (ReLU > 0)** dengan nilai aktivasi maksimum **1.090**.
   - Total waktu eksekusi simulasi 2 filter pada clock 50 MHz: **153.950 ns** (~0,154 ms).
