require "indonesian_stemmer/version"
require "indonesian_stemmer/morphological_utility"

module IndonesianStemmer

  class << self
    include MorphologicalUtility

    attr_accessor :number_of_syllables

    def stem(word, stemming_method = 'full')
      @number_of_syllables = total_syllables word

      word = remove_particle(word) if @number_of_syllables > 2
    end
  end
end
