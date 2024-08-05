# Machine Learning Image Recognition Uygulaması

Bu Swift kodları, Machine Learning Image Recognition uygulamasının çeşitli bölümlerini oluşturan bileşenlerdir. Uygulama, kullanıcıların fotoğraf seçmelerini ve bu fotoğrafları makine öğrenmesi modeliyle tanıtarak sonuçları görüntülemelerini sağlar. Her bir kod bloğu, belirli bir işlevi yerine getirir ve birlikte çalışarak tam bir görüntü tanıma uygulaması oluşturur.

## 1. Ana Ekran (ViewController.swift)

Bu kod, kullanıcıların fotoğraf seçmelerini ve seçilen fotoğrafı makine öğrenmesi modeliyle analiz ederek sonuçları göstermelerini sağlar.

### Özellikler

- **Arayüz Elemanları:**
  - `imageView`: Seçilen fotoğrafı gösterir.
  - `resultLabel`: Tanıma sonucunu gösterir.

### Fotoğraf Seçme

- `changeClicked`: Kullanıcı fotoğraf seçmek için bu butona tıkladığında, PHPickerViewController kullanılarak fotoğraf seçme işlemi başlatılır.

### Fotoğraf Seçme İşlemi

- `picker(_:didFinishPicking:)`: Kullanıcı bir fotoğraf seçtiğinde, seçilen fotoğrafı `imageView`'a atar ve makine öğrenmesi modeliyle analiz etmek için `chosenImage` değişkenine kaydeder.

### Görüntü Tanıma İşlevi

- `recognizerImage(image:)`: Seçilen fotoğrafı makine öğrenmesi modeliyle analiz eder ve sonuçları `resultLabel`'da gösterir.

![Simulator Screen Recording - iPhone 15 Pro - 2024-08-05 at 14 28 19](https://github.com/user-attachments/assets/368f2df3-a027-4af3-81af-2e9c94c1da8f)
