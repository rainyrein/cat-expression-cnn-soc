# Algoritma CNN & Kuantisasi Hardware (Python)

Folder ini berisi skrip dan *notebook* **Python** yang digunakan untuk memproses dataset citra wajah kucing, melatih model *Convolutional Neural Network* (CNN), memvalidasi akurasi perangkat lunak, serta mengekspor bobot terkuantisasi ke format heksadesimal (`.hex`) untuk diimplementasikan pada Verilog HDL.

## Daftar File

| Nama File | Fungsi Utama |
| :--- | :--- |
| **`Untitled0.ipynb`** | *Jupyter / Google Colab Notebook* utama yang menjalankan seluruh pipeline pelatihan model CNN 3-blok (input grayscale **64x64 piksel**), evaluasi pada 96 data uji (**akurasi 86.46%**), visualisasi prediksi ekspresi, serta kuantisasi bobot konvolusi dan *classifier* ke bilangan bulat 8-bit (`int8`). |
| **`preprocess_and_cnn.py`** | Skrip Python terpisah untuk membaca citra berformat `.bmp`, melakukan pemotongan wajah (*auto-crop* 60x60 piksel) ditambah 2 piksel *zero-padding* menjadi 64x64 piksel, dan menguji logika inferensi CNN. |

## Alur Proses di Python

1. **Pembacaan & Preprocessing Citra**: Membaca citra dataset, mengonversi ke skala abu-abu (*grayscale*), mengubah ukuran menjadi 60x60 piksel, dan menambahkan 2 piksel *blank/zero-padding* di setiap sisi menjadi **64x64 piksel**.
2. **Pelatihan Model CNN**: Melatih arsitektur CNN 3-blok menggunakan 864 data latih dan mengujinya pada 96 data uji independen dengan capaian **akurasi testing 86.46%**.
3. **Ekspor ke Format `.hex`**: Mengonversi bobot filter konvolusi, bobot *fully-connected classifier*, bias, serta vektor fitur citra uji ke file `.hex` (`cnn_weights.hex`, `fc_weights.hex`, `fc_bias.hex`, `cat_sample_image.hex`, `test_features.hex`, `test_labels.hex`) untuk dibaca langsung oleh modul Verilog melalui `$readmemh`.
