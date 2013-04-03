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
    isah otong otret uja uji ukul usat utar-balik utus )

  IRREGULARS_FOR_WORDS_BEGINS_WITH_N = %w( aas ada adi afi afsu aif aik akal akoda
    alar ama anti arasi asab asib asional atif asehat asihat atural etral ikah )

  IRREGULARS_FOR_WORDS_BEGINS_WITH_R = %w( aba abak aban abas abat abet abit
    abuk abun abung abut acak acau acik acuh acun adah adai adak adang adiasi
    adikal adio adu aga agam agas agi agu aguk ahap ahasia ahat ahim ahmat aih
    aja ajah ajalela ajam ajang ajin ajuk ajut akap akat akit aksi akuk akus
    akut akyat alat alip amah amahtamah amah-tamah amai amal ambah ambai ambak
    amban ambang ambat ambeh ambu ambut amin ampai ampak ampang ampas ampat
    amping ampok ampung ampus amu amus anap anca ancah ancak ancang ancap
    ancu ancung anda andai andak andat andau andek anduk andung angah angai
    angak anggah asa usak )

  IRREGULAR_PREFIX_CHARACTERS_ON_WORDS = {
    'meng' => IRREGULARS_FOR_WORDS_BEGINS_WITH_K,
    'peng' => IRREGULARS_FOR_WORDS_BEGINS_WITH_K,
    'mem' => IRREGULARS_FOR_WORDS_BEGINS_WITH_P,
    'pem' => IRREGULARS_FOR_WORDS_BEGINS_WITH_P,  }

  IRREGULAR_WORDS_ENDS_WITH_COMMON_CHARACTERS = {
    'kah' => %w(  bengkah berkah bingkah bongkah cekah firkah halakah halkah
                  harakah ingkah jangkah jerkah kalah kekah kelakah kerakah kerkah
                  khalikah langkah lukah markah mukah musyarakah nafkah naskah
                  nikah pangkah rakah rekah rengkah sedekah sekah serakah serkah
                  sungkah takah tekah telingkah tingkah tongkah ),

    'lah' => %w(  balah belah beslah bilah celah galah islah istilah jumlah
                  kalah kelah kilah lalah lelah makalah malah masalah
                  muamalah mujadalah mukabalah olah onslah oplah pecahbelah
                  pecah-belah pilah milah sekolah rihlah risalah salah serlah
                  silsilah sudah sulalah telah tulah ulah uzlah walah wasilah ),

    'pun' => %w(  ampun depun himpun lapun rapun rumpun ),

    'ku'  => %w(  awabeku baku bangku beku beluku biku buku ceku ciku cuku deku
                  jibaku kaku laku leku liku luku paku pangku peku perilaku saku
                  siku suku teleku terungku tungku waluku ),

    'mu'  => %w(  ilmu jamu jemu kemu ramu selumu tamu temu ),

    'nya' => %w(  tanya  ),
  }

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
              unless ambiguous_with_characters?(word, characters, position)
                @flags ||= collection_for(characters, 'removed')
                reduce_syllable
                slice_word_at_position(word, characters.size, position)
                return word
              end
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

              if WITH_VOWEL_SUBSTITUTION_PREFIX_CHARACTERS.include?(characters) ||
                    contains_irregular_prefix?(word, characters)

                @flags ||= collection_for(characters, 'removed')
                reduce_syllable
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
          collection.any? { |w| starts_with?(chopped_word, chopped_word.size, w) }
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

        def ambiguous_with_characters?(word, characters, position)
          if position == :start
            if characters == 'per'
              chopped_word_match_words_collection?(word[3..-1],
                  IRREGULARS_FOR_WORDS_BEGINS_WITH_R )
            else
              return false
            end
          else
            IRREGULAR_WORDS_ENDS_WITH_COMMON_CHARACTERS[characters].any? do |ambiguous_word|
              # To differentiate 'mobilmu' with 'berilmu'
              return false unless %w(me be pe).include?(word[0,2])
              # The rest is ok
              ends_with?(word, word.size, ambiguous_word)
            end
          end
        end

        def reduce_syllable
          @number_of_syllables -= 1
        end
    end
  end
end