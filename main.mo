import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
actor {
    type Gun = {
        ad : Text;
        urunler : [Urun];
    };
    type Urun = {
        ad : Text;
        fiyat : Nat;
    };
    type SecilenUrun = {
        ad : Text;
        fiyat : Nat;
        adet : Nat;
        toplamTutar : Nat;
    };
    type ZRapor = {
        tarih : Time.Time;
        gun : Text;
        secilenUrunler : [SecilenUrun];
        toplamTutar : Nat;
    };
    private let gunler = HashMap.HashMap<Text, Gun>(10, Text.equal, Text.hash);
    private stable var zRaporlari : [ZRapor] = [];
    private stable var sonZRaporTutari : Nat = 0;
    public func gunEkle(ad : Text) : async Result.Result<Text, Text> {
        if (Text.size(ad) == 0) {
            return #err("Gün boş olamaz");
        };
        if (gunler.get(ad) != null) {
            return #err("Bu gün zaten var");
        };
        let yeniGun : Gun = {
            ad = ad;
            urunler = [];
        };
        gunler.put(ad, yeniGun);
        return #ok("Gün başarıyla eklendi");
    };
    public func urunEkle(ad : Text, urunAdi : Text, fiyat : Nat) : async Result.Result<Text, Text> {
        switch (gunler.get(ad)) {
            case (null) { return #err("Gün bulunamadı"); };
            case (?kategori) {
                let yeniUrun : Urun = {
                    ad = urunAdi;
                    fiyat = fiyat;
                };
                let guncelUrunler = Array.append(kategori.urunler, [yeniUrun]);
                let guncelKategori : Gun = {
                    ad = kategori.ad;
                    urunler = guncelUrunler;
                };
                gunler.put(ad, guncelKategori);
                return #ok("Ürün başarıyla eklendi");
            };
        };
    };
    public func zRaporuHesapla(gunAdi : Text, secilenUrunler : [(Text, Nat)]) : async {
        secilenUrunDetaylari : [SecilenUrun];
        toplamTutar : Nat;
    } {
        switch (gunler.get(gunAdi)) {
            case (null) {
                return { secilenUrunDetaylari = []; toplamTutar = 0; };
            };
            case (?gun) {
                var secilenUrunDetaylari : [SecilenUrun] = [];
                var toplamTutar = 0;
                for ((ad, adet) in secilenUrunler.vals()) {
                    label l for (urun in gun.urunler.vals()) {
                        if (urun.ad == ad) {
                            let urunToplami = urun.fiyat * adet;
                            let secilenUrunDetayi : SecilenUrun = {
                                ad = urun.ad;
                                fiyat = urun.fiyat;
                                adet = adet;
                                toplamTutar = urunToplami;
                            };
                            secilenUrunDetaylari := Array.append(secilenUrunDetaylari, [secilenUrunDetayi]);
                            toplamTutar += urunToplami;
                            break l;
                        };
                    };
                };
                let yeniZRapor : ZRapor = {
                    tarih = Time.now();
                    gun = gunAdi;
                    secilenUrunler = secilenUrunDetaylari;
                    toplamTutar = toplamTutar;
                };
                zRaporlari := Array.append(zRaporlari, [yeniZRapor]);
                sonZRaporTutari := toplamTutar;
                return {
                    secilenUrunDetaylari = secilenUrunDetaylari;
                    toplamTutar = toplamTutar;
                };
            };
        };
    };
    public query func tumZRaporlarToplami() : async Nat {
        var toplam = 0;
        for (rapor in zRaporlari.vals()) {
            toplam += rapor.toplamTutar;
        };
        toplam
    };
    public query func tumZRaporlariGoster() : async [ZRapor] {
        zRaporlari
    };
    public func sonZRaporuSil() : async Result.Result<Text, Text> {
        switch (Array.size(zRaporlari)) {
            case 0 { #err("Silinecek Z raporu bulunmamaktadır") };
            case (n) {
                zRaporlari := Array.tabulate(n - 1, func(i : Nat) : ZRapor { zRaporlari[i] });
                sonZRaporTutari := 0;
                #ok("Son Z raporu başarıyla silindi")
            };
        }
    };
    public query func sonZRaporTutariniGoster() : async Nat {
        sonZRaporTutari
    };
    public query func gunleriListele() : async [Text] {
        Iter.toArray(gunler.keys())
    };
    public query func urunleriListele(gunAdi : Text) : async [Urun] {
        switch (gunler.get(gunAdi)) {
            case (null) { [] };
            case (?gun) { gun.urunler };
        };
    };
}
