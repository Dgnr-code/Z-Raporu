# Z Rapor Sistemi

## Proje Tanımı

Bu proje, mağaza veya satış noktalarındaki günlük satış verilerini yönetmek için geliştirilmiş bir sistemdir. Kullanıcılar, her bir gün için ürün ekleyebilir, belirli ürünlerin satışıyla ilgili Z raporları oluşturabilir ve geçmiş raporları görüntüleyebilirler. Bu sistem, Internet Computer platformunda, Motoko dilinde yazılmıştır.

## Özellikler

- **Gün Ekleme**: Yeni bir gün eklenebilir. Her gün, o güne ait ürünlerle ilişkilendirilecektir.
- **Ürün Ekleme**: Eklenen bir güne, belirli ürünler eklenebilir. Ürün adı ve fiyatı belirtilir.
- **Z Raporu Hesaplama**: Bir gün için seçilen ürünler ve adetleri ile Z raporu hesaplanabilir. Bu rapor, o günün satış verilerini içerir.
- **Z Raporlarını Görüntüleme**: Tüm Z raporları toplanabilir ve listelenebilir.
- **Son Z Raporunu Silme**: Son Z raporu silinebilir.
- **Toplam Z Raporu Tutarı**: Tüm Z raporlarının toplam tutarı hesaplanabilir.
- **Ürün Listeleme**: Bir gün için o günün ürünleri listelenebilir.

## Veritabanı Yapısı

### `Gun`
- **ad**: Gün adı (örneğin: "01.11.2024")
- **urunler**: O gün için eklenmiş olan ürünlerin listesi.

### `Urun`
- **ad**: Ürün adı.
- **fiyat**: Ürünün fiyatı.

### `SecilenUrun`
- **ad**: Seçilen ürün adı.
- **fiyat**: Ürünün fiyatı.
- **adet**: Satılan ürün adedi.
- **toplamTutar**: Toplam satış tutarı (fiyat x adet).

### `ZRapor`
- **tarih**: Z raporunun oluşturulduğu tarih.
- **gun**: Z raporunun ait olduğu gün adı.
- **secilenUrunler**: O gün için seçilen ürünlerin detayları.
- **toplamTutar**: O günün toplam satış tutarı.

## Fonksiyonlar

### `gunEkle(ad: Text)`: 
Yeni bir gün ekler. Eğer belirtilen gün adı daha önce eklenmişse hata döner. Eğer gün adı boşsa, geçersiz kabul edilir.

```motoko
await gunEkle("01.11.2024");
