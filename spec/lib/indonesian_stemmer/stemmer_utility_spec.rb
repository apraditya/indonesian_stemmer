require 'spec_helper'

describe IndonesianStemmer::StemmerUtility do
  before do
    class AClass
      include IndonesianStemmer::StemmerUtility
    end
    @an_object = AClass.new
    @word = 'asldkamsdo'
  end

  describe "the word #starts_with? prefix" do
    it 'that have different letters from the prefix should return false' do
      @an_object.starts_with?(@word, 3, 'ber').should be_falsey
    end

    describe "that have the same letters with the word's first letters" do
      before do
        @prefix = 'asld'
      end

      it "by exactly prefix length should be true" do
        @an_object.starts_with?(@word, @prefix.size, @prefix).should be_truthy
      end

      it "by more than prefix length should still be true" do
        @an_object.starts_with?(@word, @prefix.size+1, @prefix).should be_truthy
      end

      it "by less than prefix length should be false" do
        @an_object.starts_with?(@word, @prefix.size-1, @prefix).should be_falsey
      end
    end
  end

  describe "the word #ends_with? suffix" do
    it 'that have different letters from the suffix should return false' do
      @an_object.ends_with?(@word, 3, 'abc').should be_falsey
    end

    describe "that have the same letters with the word's last letters" do
      before do
        @suffix = 'amsdo'
      end

      it "by exactly suffix length should be true" do
        @an_object.ends_with?(@word, @suffix.size, @suffix).should be_truthy
      end

      it "by more than suffix length should still be true" do
        @an_object.ends_with?(@word, @suffix.size+1, @suffix).should be_truthy
      end

      it "by less than suffix length should be false" do
        @an_object.ends_with?(@word, @suffix.size-1, @suffix).should be_falsey
      end
    end
  end
end
