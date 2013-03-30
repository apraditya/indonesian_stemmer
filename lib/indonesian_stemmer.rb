require "indonesian_stemmer/version"
require "indonesian_stemmer/morphological_utility"

module IndonesianStemmer

  class << self
    include MorphologicalUtility

    attr_accessor :number_of_syllables

    def stem(word, derivational_stemming = true)
      @flags = 0
      @number_of_syllables = total_syllables word

      remove_particle(word) if still_has_many_syllables?
      remove_possessive_pronoun(word) if still_has_many_syllables?

      stem_derivational(word) if derivational_stemming

      word
    end


    private
      def stem_derivational(word)
        previous_size = word.size
        remove_first_order_prefix(word) if still_has_many_syllables?
        if previous_size != word.size
          previous_size = word.size
          remove_suffix(word) if still_has_many_syllables?

          if previous_size != word.size
            remove_second_order_prefix(word) if still_has_many_syllables?
          end
        else
          remove_second_order_prefix(word) if still_has_many_syllables?
          remove_suffix(word) if still_has_many_syllables?
        end
      end

      def still_has_many_syllables?
        @number_of_syllables > 2
      end
  end
end
