# Implementasi Hardware RTL (Verilog HDL & ModelSim)

Folder ini berisi seluruh kode sumber perangkat keras **Verilog HDL**, *testbench*, dan file memori bobot/fitur terkuantisasi (`.hex`) yang dikompilasi dan diverifikasi pada **ModelSim** dan **Intel Quartus Prime**.

## Daftar File

| Nama File | Kegunaan |
| :--- | :--- |
| **`CustomIP.v`** | Modul akselerator konvolusi 2D (kernel 3x3) + fungsi aktivasi ReLU untuk citra **64x64 piksel**. |
| **`tb_CustomIP.v`** | *Testbench* verifikasi gelombang *waveform* dan waktu komputasi konvolusi (153.950 ns pada clock 50 MHz). |
| **`CustomIP_Classifier.v`** | Modul klasifikasi terkuantisasi 8-bit (*signed int8*) untuk memprediksi 4 kelas ekspresi wajah kucing. |
| **`tb_Accuracy.v`** | *Testbench* pengujian akurasi otomatis pada seluruh **96 citra uji** (**akurasi hardware 85.42% / 82 dari 96 benar**). |
| **`*.hex`** | File memori bobot konvolusi, bobot *classifier*, bias, dan data fitur uji hasil kuantisasi Python. |
