require "indonesian_stemmer/version"
require "lucene_analysis/stemmer_utility"

module IndonesianStemmer
  VOWEL_CHARACTERS              = %w( a e i o u )
  PARTICLE_CHARACTERS           = %w( kah lah pun )
  POSSESSIVE_PRONOUN_CHARACTERS = %w( ku mu nya )
  FIRST_ORDER_PREFIX_CHARACTERS = %w( meng meny men mem me peng peny pen pem di ter ke )

  SPECIAL_FIRST_ORDER_PREFIX_CHARACTERS = %w( meny peny pen )

  REMOVED_KE    = 1
  REMOVED_PENG  = 2
  REMOVED_DI    = 4
  REMOVED_MENG  = 8
  REMOVED_TER   = 16
  REMOVED_BER   = 32
  REMOVED_PE    = 64

  class << self
    include LuceneAnalysis::StemmerUtility
    attr_accessor :number_of_syllables

    def stem(word, stemming_method = 'full')
      @number_of_syllables = total_syllables word

      word = remove_particle(word) if @number_of_syllables > 2
    end

    def total_syllables(word)
      result = 0
      word.size.times do |i|
        result += 1 if is_vowel?(word[i])
      end
      result
    end

    def remove_particle(word)
      @number_of_syllables ||= total_syllables(word)
      remove_characters_matching_collection(word,
                                            collection_for(:particle),
                                            :end )
    end

    def remove_possessive_pronoun(word)
      @number_of_syllables ||= total_syllables(word)
      remove_characters_matching_collection(word,
                                            collection_for(:possessive_pronoun),
                                            :end )
    end

    def remove_first_order_prefix(word)
      @number_of_syllables ||= total_syllables(word)

      word_size = word.size
      SPECIAL_FIRST_ORDER_PREFIX_CHARACTERS.each do |characters|
        characters_size = characters.size
        if starts_with?(word, word_size, characters) && word_size > characters_size && is_vowel?(word[characters_size])
          @flags ||= collection_for(characters, 'removed')
          @number_of_syllables -= 1
          word = substitute_word_character(word, characters)
          slice_word_at_position( word,
                                  characters_size-1,
                                  :start )
          return word
        end
      end

      remove_characters_matching_collection( word,
                                            collection_for(:first_order_prefix),
                                            :start )
    end


    private
      def is_vowel?(character)
        VOWEL_CHARACTERS.include? character
      end

      def collection_for(name, type = 'characters')
        constant_name = if type == 'characters'
          "#{name}_#{type}"
        else
          name =  case
                  when %w(meny men mem me).include?(name)
                    'meng'
                  when %w(peny pen pem).include?(name)
                    'peng'
                  else
                    name
                  end
          "#{type}_#{name}"
        end
        const_get("#{constant_name}".upcase.to_sym)
      end

      def remove_characters_matching_collection(word, collection, position)
        collection.each do |characters|
          if send("#{position}s_with?", word, word.size, characters)
            @number_of_syllables -= 1
            slice_word_at_position(word, characters.size, position)
            return word
          end
        end

        word
      end

      def slice_word_at_position(word, characters_size, position)
        multiplier = (position == :start)? 0 : -1
        word.slice!( multiplier*characters_size, characters_size)
      end

      def substitute_word_character(word, characters)
        substitute_char = case
        when %w(meny peny).include?(characters)
          's'
        when characters == 'pen'
          't'
        end
        word[characters.size-1] = substitute_char if substitute_char
        word
      end
  end
end
