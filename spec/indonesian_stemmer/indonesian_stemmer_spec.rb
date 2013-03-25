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
end
