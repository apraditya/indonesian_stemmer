# IndonesianStemmer

[![Gem Version](https://badge.fury.io/rb/indonesian_stemmer.png)](http://badge.fury.io/rb/indonesian_stemmer)
[![Build Status](https://secure.travis-ci.org/apraditya/indonesian_stemmer.png)](http://travis-ci.org/apraditya/indonesian_stemmer)
[![Dependency Status](https://gemnasium.com/apraditya/indonesian_stemmer.png)](https://gemnasium.com/apraditya/indonesian_stemmer)
[![Code Climate](https://codeclimate.com/github/apraditya/indonesian_stemmer.png)](https://codeclimate.com/github/apraditya/indonesian_stemmer)


Stem kata bahasa Indonesia berdasarkan Porter Stemmer, dengan menggunakan algoritma yang dipaparkan dalam paper [**A Study of Stemming Effects on Information Retrieval in Bahasa Indonesia**](http://www.illc.uva.nl/Publications/ResearchReports/MoL-2003-02.text.pdf), oleh Fadillah Z Tala.

English translation is available [here](https://github.com/apraditya/indonesian_stemmer/blob/master/README-EN.md).

## Instalasi

Tambahkan baris ini di Gemfile aplikasi anda:

    gem 'indonesian_stemmer'

Kemudian jalankan:

    $ bundle

Atau instal sendiri seperti ini:

    $ gem install indonesian_stemmer

## Penggunaan

    require 'rubygems'
    require 'indonesian_stemmer'

    IndonesianStemmer.stem('mendengarkan')  # => "dengar"
    'beriman'.stem                          # => "iman"

Atau mencobanya langsung dari web: [indonesian-stemmer.adindap.com](http://indonesian-stemmer.adindap.com).

## Masalah-masalah yang Diketahui
Gem ini masih dalam tahap pengembangan dan penyempurnaan. Meskipun sudah banyak upaya dalam pemilihan kata dan penanganan kata-kata yang ambigu, jangan mengandalkan gem ini untuk analisa ilmiah atau proyek lainnya. Berikut adalah masalah-masalah yang diketahui atau kasus-kasus yang tidak ditangani oleh gem ini dengan benar:

1. Kata-kata turunan yang memiliki kata dasar yang berbeda. Contohnya `memasak` yang memiliki 2 kata dasar yang sama, yaitu `pasak` dan `masak`. Saat ini kami mutuskan untuk mengeluarkan hasil kata dasar berdasarkan kata yang lebih umum digunakan (menurut pendapat kami). Dalam contoh ini, kata `masak` yang kami pilih.
2. Kata-kata turunan yang berasal dari kata dasar yang hanya mengandung 1 suku kata. Contohnya `mengebom` yang berasal dari kata `bom`.
3. Tidak menangani awalan se-, semua bentuk sisipan.

Jika ada masalah lain di luar hal-hal di atas, silahkan buat [tiket baru](https://github.com/apraditya/indonesian_stemmer/issues/new)

## Berkontribusi
Awalnya, gem ini merupakan implementasi dari sistem penganalisa untuk bahasa Indonesia, dari proyek [Apache Lucene](http://lucene.apache.org/), ke dalam bahasa Ruby. Gem ini sudah mengalami beberapa perubahan algoritma dalam mengenali awalan kata, terutama terhadap kata-kata yang ambigu.

### Referensi
1. [Situs Resmi Kamus Bahasa Indonesia](http://bahasa.kemdiknas.go.id/kbbi/index.php)
2. Untuk mencari dan memverifikasi kata indonesia, [Kateglo Bahtera](http://kateglo.bahtera.org/)
3. Artikel Wikipedia yang berjudul [Prefiks dalam Bahasa Indonesia](http://id.wikipedia.org/wiki/Prefiks_dalam_bahasa_Indonesia) 

### Langkah-langkah
1. *Fork* proyek ini
2. Buat branch untuk fitur anda (`git checkout -b my-new-feature`)
3. *Commit* perubahan-perubahan yang anda buat (`git commit -am 'Tambahkan fitur baru'`)
4. *Push* ke branch itu (`git push origin my-new-feature`)
5. Ajukan ***Pull Request*** baru

## Terima kasih
Setelah bersyukur kepada Allah Subhanahu Wa Ta'ala, kami ingin mengucapkan terima kasih kepada:

- Fadillah Z Tala & [Apache Lucene](http://lucene.apache.org/) sehingga kami dapat mulai membuat gem ini
- Penyedia [Kateglo Bahtera](http://kateglo.bahtera.org/), karena telah menyediakan API nya sehingga saya bisa memilih & memisahkan kata-kata ambigu, dan akhirnya memeriksa validitas hasil kata.
