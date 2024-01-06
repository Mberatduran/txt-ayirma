#!/bin/bash

# Program girilen 1.Argümanı (satır sayısını) girilen 2.Argümana (kaç dosya olacağına) bölerek yeni oluşturulan her bir dosyaya kaç veri düşeceğini hesaplar Eğer tam bölünmüyorsa kalan kısmı for döngüsü ile açılmış olan dosyalara tek tek dağıtır.

# Bu verileri dosyaya yazdırma kısmında ise while içerisindeki satır sayısı bir bir artırılıp, kaç veri yazılacağına eşit olduğunda hangiSatirda değeri sıfırlanıp dosya adını günceller.


# Mehmet Berat Duran
# 200707056
# Bilgisayar Mühendisliği
# Kabuk Programlama BMS-301
# Güz Dönemi 2022
# Proje 1
# Dr. Öğr. Üyesi Deniz DAL



# Argüman sayısı 2 den fazla ise hata verir.

count=0
for var in "$#"
do
    (( count++ ))
done

if [ $count -gt 2 ]; then
    echo "Arguman sayisi 2 den fazla olamaz"
    exit
fi

# Veriseti olarak kullanılacak olan dosyanın bulunmaması halinde hata verir.

if [ ! -f "$1" ]; then
    echo "$1 dosyasi bulunamadi."
    exit
fi

# 2. Argüman sayı değilse veya pozitif sayı değilse hata verir.

if [[ $2 =~ [^0-9] ]]; then  # "integer expression expected" bu hatadan dolayı regex kullanılarak kontrol ettirildi.
    echo "$2 argumani sayi olmadilir."
    exit
elif [ ! $2 -gt 0 ]; then
    echo "$2 sayisi sifirdan buyuk olmalidir."
    exit
fi

# 2. Argüman değeri toplam satır sayısından(1.Argümandan) büyükse hata verir.

satirSayisi=$(wc -l < $1)

if [ $2 -gt $satirSayisi ]; then
    echo "2. arguman degeri satir sayisindan buyuk olamaz"
    exit
fi

# kacVeriYazilicak=$(( ( $satirSayisi / $2 ) + ( $satirSayisi % $2 > 0 ) ))
kacVeriYazilicak=$(( $satirSayisi / $2 )) # Her bir dosyaya düşen veri sayısını hesaplar.

# 1.Argüman olarak girilen dosyanın adını ve uzantısını yeni dosyalar oluştururken kullanmak için ayrıştırır.
fileName=$(basename $1)
file=$(echo $fileName | cut -d '.' -f1)
fileExt=$(echo $fileName | cut -d '.' -f2)

hangiSatirda=0
hangiDosyada=1
dosyaAdi=$(echo $file"-1".$fileExt) # Yeni Dosyaları oluşturur.
while read -r line; do
    if [ $hangiDosyada -gt $2 ]; then
        fazlaVeriler+=($line) #fazla veriler değişkene atıldı
    else
         (( hangiSatirda++ ))
        if [ $hangiSatirda = $kacVeriYazilicak ]; then
        echo -n $line >> $dosyaAdi # Son satırda boşluk kalmasın.
        echo "$dosyaAdi dosyası oluşturuldu."
        (( hangiDosyada++ ))
        dosyaAdi=$(echo $file"-"$hangiDosyada.$fileExt)
        (( hangiSatirda = 0 ))
        else
            echo $line >> $dosyaAdi
        fi
    fi
done < $1

# fazla değişken for ile okundu ve içerisindeki değerler dosyaları tek tek açarak yazıldı.
hangiDosyada=0
for name in "${fazlaVeriler[@]}"; do 
    (( hangiDosyada++ ))
    dosyaAdi=$(echo $file"-"$hangiDosyada.$fileExt)
    if [ $hangiDosyada = $2 ]; then
        hangiDosyada=0
    fi
    echo "" >> $dosyaAdi
    echo -n "$name" >> $dosyaAdi
done
