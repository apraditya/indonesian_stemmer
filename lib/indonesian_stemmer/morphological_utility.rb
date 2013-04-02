require "indonesian_stemmer/stemmer_utility"

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

  IRREGULARS_FOR_WORDS_BEGINS_WITH_K  = %w(
    aget alah andung ata ejar eluar embali empis emuka ena enal encang endali ering
    erja erut etahui etik ibar irim uasai uliti umpul unci unjung unyah upas urang )

  IRREGULARS_FOR_WORDS_BEGINS_WITH_P  = %w(
    adam ahat akai amer anas ancang anggang anggil anjat antul asang asti atuhi
    ecah ecat elihara eluk ercik eriksa erintah esan ikir ilah ilih injam inta
    isah otong otret uja uji ukul usat utar-balikkan utus )

  IRREGULARS_FOR_WORDS_BEGINS_WITH_N = %w( aas ada adi afi afsu aif aik akal akoda
    alar ama angis anti arasi asab asib asional atif asehat asihat etral atural )

  IRREGULAR_PREFIX_CHARACTERS_ON_WORDS = {
    'meng' => IRREGULARS_FOR_WORDS_BEGINS_WITH_K,
    'peng' => IRREGULARS_FOR_WORDS_BEGINS_WITH_K,
    'mem' => IRREGULARS_FOR_WORDS_BEGINS_WITH_P,
    'pem' => IRREGULARS_FOR_WORDS_BEGINS_WITH_P,  }

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

        remove_and_substitute_characters_matching_collection(
            word, collection_for(:special_first_order_prefix), :start )

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
            if send("#{position}s_with?", word, word.size, characters)
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
          word_size = word.size
          collection.each do |characters|
            characters_size = characters.size
            if send("#{position}s_with?", word, word_size, characters) &&
                  word_size > characters_size && is_vowel?(word[characters_size])

              @flags ||= collection_for(characters, 'removed')
              reduce_syllable

              if WITH_VOWEL_SUBSTITUTION_PREFIX_CHARACTERS.include?(characters) ||
                    contains_irregular_prefix?(word, characters)

                word = substitute_word_character(word, characters)
                slice_word_at_position( word,
                                        characters_size-1,
                                        :start )
                return word
              end
            end
          end
        end

        def contains_irregular_prefix?(word, characters)
          if IRREGULAR_PREFIX_CHARACTERS_ON_WORDS.keys.include?(characters)
            chopped_word_match_words_collection?(
              word[characters.size, word.size],
              IRREGULAR_PREFIX_CHARACTERS_ON_WORDS[characters] )
          end
        end

        def chopped_word_match_words_collection?(chopped_word, collection)
          collection.any? { |w| w == chopped_word }
        end

        def substitute_word_character(word, characters)
          substitute_char = case
          when %w(meny peny).include?(characters)
            's'
          when %w(men pen).include?(characters)
            (chopped_word_match_words_collection?(
                word[characters.size, word.size], IRREGULARS_FOR_WORDS_BEGINS_WITH_N
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

        def reduce_syllable
          @number_of_syllables -= 1
        end
    end
  end
end