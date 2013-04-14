require "indonesian_stemmer/stemmer_utility"
require "indonesian_stemmer/irregular_words"

module IndonesianStemmer

  VOWEL_CHARACTERS                            = %w( a e i o u )
  PARTICLE_CHARACTERS                         = %w( kah lah pun )
  POSSESSIVE_PRONOUN_CHARACTERS               = %w( ku mu nya )
  FIRST_ORDER_PREFIX_CHARACTERS               = %w( meng meny men mem me
                                                    peng peny pen pem di ter ke )
  SPECIAL_FIRST_ORDER_PREFIX_CHARACTERS       = %w( meng peng meny peny men pen
                                                    mem pem )
  SECOND_ORDER_PREFIX_CHARACTERS              = %w( ber be per pe )
  NON_SPECIAL_SECOND_ORDER_PREFIX_CHARACTERS  = %w( ber per pe )
  SPECIAL_SECOND_ORDER_PREFIX_WORDS           = %w( belajar pelajar belunjur )
  SUFFIX_CHARACTERS                           = %w( kan an i )
  WITH_VOWEL_SUBSTITUTION_PREFIX_CHARACTERS   = %w( meny peny men pen )


  REMOVED_KE    = 1
  REMOVED_PENG  = 2
  REMOVED_DI    = 4
  REMOVED_MENG  = 8
  REMOVED_TER   = 16
  REMOVED_BER   = 32
  REMOVED_PE    = 64


  module MorphologicalUtility
    include StemmerUtility

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end

    module InstanceMethods
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

        previous_word = word.dup
        remove_and_substitute_characters_matching_collection(
            word, collection_for(:special_first_order_prefix), :start )
        return word if previous_word != word

        remove_characters_matching_collection( word,
                                              collection_for(:first_order_prefix),
                                              :start )
      end

      def remove_second_order_prefix(word)
        @number_of_syllables ||= total_syllables(word)
        word_size = word.size

        if SPECIAL_SECOND_ORDER_PREFIX_WORDS.include?(word)
          @flags ||= REMOVED_BER if word[0..1] == 'be'
          reduce_syllable
          slice_word_at_position(word, 3, :start)
          return word
        end

        if starts_with?(word, word_size, 'be') && word_size > 4 && !is_vowel?(word[2]) && word[3..4] == 'er'
          @flags ||= REMOVED_BER
          reduce_syllable
          slice_word_at_position(word, 2, :start)
          return word
        end

        remove_characters_matching_collection(word,
                                              collection_for(:non_special_second_order_prefix),
                                              :start)
      end

      def remove_suffix(word)
        return word if ambiguous_with_suffices_ending_words?(word)

        @number_of_syllables ||= total_syllables(word)

        SUFFIX_CHARACTERS.each do |character|
          constants_to_check = case character
          when 'kan'
            [REMOVED_KE, REMOVED_PENG, REMOVED_PE]
          when 'an'
            [REMOVED_DI, REMOVED_MENG, REMOVED_TER]
          when 'i'
            [REMOVED_BER, REMOVED_KE, REMOVED_PENG]
          end

          if ends_with?(word, word.size, character) &&
                constants_to_check.all? { |c| (@flags & c) == 0 }
            reduce_syllable
            slice_word_at_position(word, character.size, :end)
            return word
          end
        end

        word
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
        rescue NameError
        end

        def remove_characters_matching_collection(word, collection, position)
          collection.each do |characters|
            if match_position_and_not_ambiguous_with_characters?(word, characters, position)
              next if characters == 'mem' && is_vowel?(word[characters.size])
              @flags ||= collection_for(characters, 'removed')
              reduce_syllable
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

        def remove_and_substitute_characters_matching_collection(word, collection, position)
          collection.each do |characters|
            if matching_characters_requires_substitution?(word, characters, position)
              @flags ||= collection_for(characters, 'removed')
              reduce_syllable
              word = substitute_word_character(word, characters)
              slice_word_at_position( word,
                                      characters.size-1,
                                      :start )
              return word
            end
          end
        end

        def contains_irregular_prefix?(word, characters)
          if IrregularWords::ON_PREFIX_CHARACTERS.keys.include?(characters)
            chopped_word_match_words_collection?(
              word[characters.size, word.size],
              IrregularWords::ON_PREFIX_CHARACTERS[characters] )
          end
        end

        def chopped_word_match_words_collection?(chopped_word, collection)
          collection.any? { |w| starts_with?(chopped_word, chopped_word.size, w) }
        end

        def substitute_word_character(word, characters)
          substitute_char = case
          when %w(meny peny).include?(characters)
            's'
          when %w(men pen).include?(characters)
            (chopped_word_match_words_collection?(
                word[characters.size, word.size], IrregularWords::BEGINS_WITH_N
              )
            )? 'n' : 't'
          when %w(meng peng).include?(characters)
            'k'
          when %w(mem pem).include?(characters)
            'p'
          end
          word[characters.size-1] = substitute_char if substitute_char
          word
        end

        def ambiguous_with_characters?(word, characters, position)
          if position == :start
            if characters == 'per'
              chopped_word_match_words_collection?(word[3..-1],
                  IrregularWords::BEGINS_WITH_R )
            else
              return false
            end
          else
            IrregularWords::ENDS_WITH_COMMON_CHARACTERS[characters].any? do |ambiguous_word|
              # To differentiate 'mobilmu' with 'berilmu'
              return false unless %w(me be pe).include?(word[0,2])
              # The rest is ok
              ends_with?(word, word.size, ambiguous_word)
            end
          end
        end

        def ambiguous_with_suffices_ending_words?(word)
          IrregularWords::ENDS_WITH_SUFFIX_CHARACTERS.include?(word)
        end

        def match_position_and_not_ambiguous_with_characters?(word, characters, position)
          send("#{position}s_with?", word, word.size, characters) &&
              !ambiguous_with_characters?(word, characters, position)
        end

        def match_characters_position_followed_by_vowel?(word, characters, position)
          word_size = word.size
          characters_size = characters.size

          send("#{position}s_with?", word, word_size, characters) &&
              word_size > characters_size && is_vowel?(word[characters_size])
        end

        def substitution_required?(word, characters)
          WITH_VOWEL_SUBSTITUTION_PREFIX_CHARACTERS.include?(characters) ||
              contains_irregular_prefix?(word, characters)
        end

        def matching_characters_requires_substitution?(word, characters, position)
          match_characters_position_followed_by_vowel?(word, characters, position) &&
              substitution_required?(word, characters)
        end

        def reduce_syllable
          @number_of_syllables -= 1
        end
    end
  end
end