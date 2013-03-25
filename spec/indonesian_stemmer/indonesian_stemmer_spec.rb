require 'indonesian_stemmer'

describe IndonesianStemmer do
  describe '#total_syllables' do
    it "'memasak' should return 3" do
      IndonesianStemmer.total_syllables('memasak').should == 3
    end

    it "'mewarnai' should return 3" do
      IndonesianStemmer.total_syllables('mewarnai').should == 4
    end

    it "'permainan' should return 4" do
      IndonesianStemmer.total_syllables('permainan').should == 4
    end
  end

  describe '#remove_particle' do
    describe 'should remove the particles at the end of the word' do
      it "'kah'" do
        should_transform(:remove_particle, 'manakah', 'mana')
      end

      it "'lah'" do
        should_transform(:remove_particle, 'kembalilah', 'kembali')
      end

      it "'pun'" do
        should_transform(:remove_particle, 'bagaimanapun', 'bagaimana')
      end
    end

    describe 'should not remove the particles at the rest part of the word' do
      it "'kah'" do
        should_not_transform(:remove_particle, 'kahak')
        should_not_transform(:remove_particle, 'pernikahan')
      end

      it "'lah'" do
        should_not_transform(:remove_particle, 'lahiriah')
        should_not_transform(:remove_particle, 'kelahiran')
      end

      it "'pun'" do
        should_not_transform(:remove_particle, 'punya')
        should_not_transform(:remove_particle, 'kepunyaan')
      end
    end
  end
end

def should_transform(method_name, word, transformed_word)
  IndonesianStemmer.send(method_name, word).should == transformed_word
end

def should_not_transform(method_name, word)
  IndonesianStemmer.send(method_name, word).should == word
end