require "indonesian_stemmer/version"
require "lucene_analysis/stemmer_utility"

module IndonesianStemmer
  VOWEL_CHARACTERS              = %w( a e i o u )
  PARTICLE_CHARACTERS           = %w( kah lah pun )
  POSSESSIVE_PRONOUN_CHARACTERS = %w( ku mu nya )

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
      remove_characters_matching_collection(word, :particle, :end)
    end

    def remove_possessive_pronoun(word)
      @number_of_syllables ||= total_syllables(word)
      remove_characters_matching_collection(word, :possessive_pronoun, :end)
    end


    private
      def is_vowel?(character)
        VOWEL_CHARACTERS.include? character
      end

      def remove_characters_matching_collection(word, type, position)
        collection = const_get("#{type}_characters".upcase.to_sym)
        chars_to_remove = collection.select { |c| send("#{position}s_with?", word, word.size, c) }.first
        if chars_to_remove
          @number_of_syllables -= 1
          chars_length = chars_to_remove.size
          multiplier = (position == 'start')? 0 : -1
          word.slice!( multiplier*chars_length, chars_length)
        end
        word
      end
  end
end
