require 'spec_helper'

describe IndonesianStemmer do
  describe "covering the inflectional particles" do
    describe "'kah'" do
      it { should_stem 'bukukah', 'buku' }
    end

    describe "'lah'" do
      it { should_stem 'adalah', 'ada' }
    end

    describe "'pun'" do
      it { should_stem 'bagaimanapun', 'bagaimana' }
    end
  end

  describe "covering the inflectional possessive pronouns" do
    describe "'ku'" do
      it { should_stem 'bukuku', 'buku' }
    end

    describe "'mu'" do
      it { should_stem 'rumahmu', 'rumah' }
    end

    describe "'nya'" do
      it { should_stem 'cintanya', 'cinta' }
    end
  end

  describe "covering the first order of derivational prefixes" do
    describe "'meng'" do
      it { should_stem 'mengukur', 'ukur' }
    end

    describe "'meny'" do
      it { should_stem 'menyapu', 'sapu' }
    end

    describe "'men'" do
      it { should_stem 'menduga', 'duga' }
      it { should_stem 'menuduh', 'tuduh' }
    end

    describe "'mem' followed by 'p'" do
      it { should_stem 'memilih', 'pilih'}
      it { should_stem 'memilah', 'pilah'}
      it { should_stem 'memuji', 'puji'}
    end

    describe "'mem'" do
      it { should_stem 'membaca', 'baca'}
      it { should_stem 'membantu', 'bantu'}
    end

    describe "'me'" do
      it { should_stem 'merusak', 'rusak'}
      it { should_stem 'melayang', 'layang'}
    end

    describe "'peng'" do
      it { should_stem 'pengukur', 'ukur'}
    end

    describe "'peny'" do
      it { should_stem 'penyalin', 'salin'}
    end

    describe "'pen'" do
      it { should_stem 'penasehat', 'nasehat'}
      it { should_stem 'penarik', 'tarik'}
    end

    describe "'pem' followed by 'p'" do
      it { should_stem 'pemilih', 'pilih'}
      it { should_stem 'pemilah', 'pilah'}
      it { should_stem 'pemuji', 'puji'}
    end

    describe "'pem'" do
      it { should_stem 'pembaca', 'baca'}
    end

    describe "'di'" do
      it { should_stem 'diukur', 'ukur'}
      it { should_stem 'dilihat', 'lihat'}
    end

    describe "'ter'" do
      it { should_stem 'terindah', 'indah'}
      it { should_stem 'terhebat', 'hebat'}
      it { should_stem 'terukur', 'ukur'}
      it { should_stem 'tersapu', 'sapu'}
    end

    describe "'ke'" do
      it { should_stem 'kekasih', 'kasih'}
    end
  end

  describe "covering the second order of derivational prefixes" do
    describe "'ber'" do
      it { should_stem 'berlari', 'lari'}
    end

    describe "'bel'" do
      it { should_stem 'belajar', 'ajar'}
    end

    describe "'be'" do
      it { should_stem 'bekerja', 'kerja'}
    end

    describe "'per'" do
      it { should_stem 'perjelas', 'jelas'}
    end

    describe "'pel'" do
      it { should_stem 'pelajar', 'ajar'}
    end

    describe "'pe'" do
      it { should_stem 'pekerja', 'kerja'}
      it { should_stem 'pelari', 'lari'}
    end
  end

  describe "covering the derivational suffixes" do
    describe "'kan'" do
      it { should_stem 'tarikkan', 'tarik'}
      it { should_stem 'ambilkan', 'ambil'}
    end

    describe "'an'" do
      it { should_stem 'makanan', 'makan'}
      it { should_stem 'sarapan', 'sarap'}
    end

    describe "'i'" do
      it { should_stem 'ajari', 'ajar'}
      it { should_stem 'cermati', 'cermat'}
    end
  end
end
