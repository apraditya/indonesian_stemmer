require "indonesian_stemmer/version"
require "lucene_analysis/stemmer_utility"

module IndonesianStemmer
  VOWEL_CHARACTERS    = %w( a e i o u )
  PARTICLE_CHARACTERS = %w( kah lah pun )

  class << self
    include LuceneAnalysis::StemmerUtility
    attr_accessor :number_of_syllables

    def total_syllables(word)
      result = 0
      word.size.times do |i|
        result += 1 if is_vowel?(word[i])
      end
      result
    end

    def remove_particle(word)
      @number_of_syllables ||= total_syllables(word)
      if PARTICLE_CHARACTERS.any? { |char| ends_with?(word, word.size, char) }
        @number_of_syllables -= 1
        word.slice!( -3, 3)
      end
      word
    end


    private
      def is_vowel?(character)
        VOWEL_CHARACTERS.include? character
      end
  end
end
