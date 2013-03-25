require "indonesian_stemmer/version"

module IndonesianStemmer
  VOWEL_CHARACTERS    = %w( a e i o u )
  class << self
    def total_syllables(word)
      result = 0
      word.size.times do |i|
        result += 1 if is_vowel?(word[i])
      end
      result
    end


    private
      def is_vowel?(character)
        VOWEL_CHARACTERS.include? character
      end
  end
end
