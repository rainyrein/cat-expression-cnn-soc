# Sampel Citra Uji Terproses (64x64 Grayscale BMP)

Folder ini menyimpan sampel citra uji berformat **`.bmp`** hasil *preprocessing* dari dataset mentah dengan spesifikasi berikut:

- **Resolusi Akhir:** **64 x 64 piksel** (1-channel *grayscale* 8-bit).
- **Komposisi Piksel:** Area wajah kucing hasil *auto-crop* sebesar **60 x 60 piksel** di bagian tengah, dikelilingi **2 piksel *blank/zero-padding* (nilai 0)** di setiap sisi atas, bawah, kiri, dan kanan.
- **Kegunaan:** Digunakan oleh skrip Python untuk verifikasi pembacaan format `.bmp` serta dikonversi menjadi file memori heksadesimal (`cat_sample_image.hex`) untuk simulasi konvolusi pada Verilog HDL.
