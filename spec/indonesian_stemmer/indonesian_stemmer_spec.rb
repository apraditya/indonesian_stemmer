require 'indonesian_stemmer'

describe IndonesianStemmer do
  describe '#total_syllables' do
    it "'memasak' should return 3" do
      IndonesianStemmer.total_syllables('memasak').should == 3
    end

    it "'mewarnai' should return 3" do
      IndonesianStemmer.total_syllables('mewarnai').should == 4
    end

    it "'permainan' should return 4" do
      IndonesianStemmer.total_syllables('permainan').should == 4
    end
  end

  describe '#remove_particle' do
    describe 'should remove these particles at the end of the word' do
      it "'kah'" do
        should_transform(:remove_particle, 'manakah', 'mana')
      end

      it "'lah'" do
        should_transform(:remove_particle, 'kembalilah', 'kembali')
      end

      it "'pun'" do
        should_transform(:remove_particle, 'bagaimanapun', 'bagaimana')
      end
    end

    describe 'should not remove these particles at the rest part of the word' do
      it "'kah'" do
        should_not_transform(:remove_particle, 'kahak')
        should_not_transform(:remove_particle, 'pernikahan')
      end

      it "'lah'" do
        should_not_transform(:remove_particle, 'lahiriah')
        should_not_transform(:remove_particle, 'kelahiran')
      end

      it "'pun'" do
        should_not_transform(:remove_particle, 'punya')
        should_not_transform(:remove_particle, 'kepunyaan')
      end
    end
  end

  describe '#remove_possessive_pronoun' do
    describe 'should remove these possessive pronouns at the end of the word' do
      it "'ku'" do
        should_transform(:remove_possessive_pronoun, 'mainanku', 'mainan')
      end

      it "'mu'" do
        should_transform(:remove_possessive_pronoun, 'mobilmu', 'mobil')
      end

      it "'nya'" do
        should_transform(:remove_possessive_pronoun, 'gelasnya', 'gelas')
      end
    end

    describe 'should not remove these possessive pronouns at the rest part of the word' do
      it "'ku'" do
        should_not_transform(:remove_possessive_pronoun, 'kumakan')
        should_not_transform(:remove_possessive_pronoun, 'kekurangan')
      end

      it "'mu'" do
        should_not_transform(:remove_possessive_pronoun, 'murahan')
        should_not_transform(:remove_possessive_pronoun, 'kemurkaan')
      end

      it "'nya'" do
        should_not_transform(:remove_possessive_pronoun, 'nyapu')
        should_not_transform(:remove_possessive_pronoun, 'menyambung')
      end
    end
  end

  describe '#remove_first_order_prefix' do
    describe "words with these special characters" do
      describe "at the begining" do
        describe "followed by a vowel, should remove and substitute the last character" do
          it "'meny'" do
            should_transform(:remove_first_order_prefix, 'menyambung', 'sambung')
          end

          it "'peny'" do
            should_transform(:remove_first_order_prefix, 'penyantap', 'santap')
          end

          it "'pen'" do
            should_transform(:remove_first_order_prefix, 'penata', 'tata')
          end
        end

        describe "followed by consonant, should only remove the special characters" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'menyxxx', 'xxx')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'penyxxx', 'xxx')
          end

          it "'pen'" do
            should_transform(:remove_first_order_prefix, 'penjahat', 'jahat')
          end
        end

        describe "should set the flags correctly" do
          it "'meny'"
          it "'peny'"
          it "'pen'"
        end
      end

      describe "at the rest part of the word" do
        describe "followed by a vowel, should not do anything" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxmenyaxx', 'xxxmenyaxx')
            should_transform(:remove_first_order_prefix, 'xxxmenya', 'xxxmenya')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenyaxx', 'xxxpenyaxx')
            should_transform(:remove_first_order_prefix, 'xxxpenya', 'xxxpenya')
          end

          it "'pen'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenexx', 'xxxpenexx')
            should_transform(:remove_first_order_prefix, 'xxxpeno', 'xxxpeno')
          end
        end

        describe "followed by consonant, should not do anything" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxmenykxx', 'xxxmenykxx')
            should_transform(:remove_first_order_prefix, 'xxxmenyk', 'xxxmenyk')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenykxx', 'xxxpenykxx')
            should_transform(:remove_first_order_prefix, 'xxxpenyk', 'xxxpenyk')
          end

          it "'pen'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenrxx', 'xxxpenrxx')
            should_transform(:remove_first_order_prefix, 'xxxpenr', 'xxxpenr')
          end
        end
      end
    end

    describe "words with first order prefix characters" do
      describe "at the begining," do
        describe "should remove these characters" do
          it "'meng'" do
            should_transform(:remove_first_order_prefix, 'menggambar', 'gambar')
          end

          it "'men'" do
            should_transform(:remove_first_order_prefix, 'mendaftar', 'daftar')
          end

          it "'mem'" do
            should_transform(:remove_first_order_prefix, 'membangun', 'bangun')
          end

          it "'me'" do
            should_transform(:remove_first_order_prefix, 'melukis', 'lukis')
          end

          it "'peng'" do
            should_transform(:remove_first_order_prefix, 'penggaris', 'garis')
          end

          it "'pem'" do
            should_transform(:remove_first_order_prefix, 'pembajak', 'bajak')
          end

          it "'di'" do
            should_transform(:remove_first_order_prefix, 'disayang', 'sayang')
          end

          it "'ter'" do
            should_transform(:remove_first_order_prefix, 'terucap', 'ucap')
          end

          it "'ke'" do
            should_transform(:remove_first_order_prefix, 'kemakan', 'makan')
          end
        end

        describe "should set the flags correctly" do
          it "'meng'"
          it "'men'"
          it "'mem'"
          it "'me'"
          it "'peng'"
          it "'pem'"
          it "'di'"
          it "'ter'"
          it "'ke'"
        end
      end

      describe "at the rest part of the word, should not remove these characters" do
        it "'meng'" do
          should_transform(:remove_first_order_prefix, 'xxxmengxex', 'xxxmengxex')
          should_transform(:remove_first_order_prefix, 'xexmeng', 'xexmeng')
        end

        it "'men'" do
          should_transform(:remove_first_order_prefix, 'xxxmenxxx', 'xxxmenxxx')
          should_transform(:remove_first_order_prefix, 'xxxmen', 'xxxmen')
        end

        it "'mem'" do
          should_transform(:remove_first_order_prefix, 'xxxmemxxx', 'xxxmemxxx')
          should_transform(:remove_first_order_prefix, 'xxxmem', 'xxxmem')
        end

        it "'me'" do
          should_transform(:remove_first_order_prefix, 'xxxmexxx', 'xxxmexxx')
          should_transform(:remove_first_order_prefix, 'xxxme', 'xxxme')
        end

        it "'peng'" do
          should_transform(:remove_first_order_prefix, 'xxxpengxxx', 'xxxpengxxx')
          should_transform(:remove_first_order_prefix, 'xxxpeng', 'xxxpeng')
        end

        it "'pem'" do
          should_transform(:remove_first_order_prefix, 'xxxpemxxx', 'xxxpemxxx')
          should_transform(:remove_first_order_prefix, 'xxxpem', 'xxxpem')
        end

        it "'di'" do
          should_transform(:remove_first_order_prefix, 'xxxdixxx', 'xxxdixxx')
          should_transform(:remove_first_order_prefix, 'xxxdi', 'xxxdi')
        end

        it "'ter'" do
          should_transform(:remove_first_order_prefix, 'xxxterxxx', 'xxxterxxx')
          should_transform(:remove_first_order_prefix, 'xxxter', 'xxxter')
        end

        it "'ke'" do
          should_transform(:remove_first_order_prefix, 'xxxkexxx', 'xxxkexxx')
          should_transform(:remove_first_order_prefix, 'xxxke', 'xxxke')
        end
      end
    end
  end

  describe '#remove_second_order_prefix' do
    describe "should handle these irregular words" do
      it "'belajar'" do
        should_transform(:remove_second_order_prefix, 'belajar', 'ajar')
      end

      it "'belunjur'" do
        should_transform(:remove_second_order_prefix, 'belunjur', 'unjur')
      end

      it "'pelajar'" do
        should_transform(:remove_second_order_prefix, 'pelajar', 'ajar')
      end
    end

    describe "should handle words starting with 'be*er' where * isn't a vowel & the length > 4" do
      it "'beserta'" do
        should_transform(:remove_second_order_prefix, 'beserta', 'serta')
      end
      # TODO: Find other word(s) matching this rule
    end

    describe "words with second order prefix characters" do
      describe "at the begining," do
        describe "should remove these characters" do
          it "'ber'" do
            should_transform(:remove_second_order_prefix, 'bercerita', 'cerita')
          end

          it "'per'" do
            should_transform(:remove_second_order_prefix, 'perjelas', 'jelas')
          end

          it "'pe'" do
            should_transform(:remove_second_order_prefix, 'pesuruh', 'suruh')
          end
        end

        describe "should set the flags correctly" do
          it "'ber'"
          it "'per'"
          it "'pe'"
        end
      end

      describe "at the rest part of the word, should not remove these characters" do
        it "'ber'" do
          should_not_transform(:remove_second_order_prefix, 'xxxberxxx')
          should_not_transform(:remove_second_order_prefix, 'xxxber')
        end

        it "'per'" do
          should_not_transform(:remove_second_order_prefix, 'xxxperxxx')
          should_not_transform(:remove_second_order_prefix, 'xxxper')
        end

        it "'pe'" do
          should_not_transform(:remove_second_order_prefix, 'xxxpexxx')
          should_not_transform(:remove_second_order_prefix, 'xxxpe')
        end
      end
    end
  end

  describe '#remove_suffix' do
    describe "words with these suffix characters" do
      describe "at the end of the word, should remove the suffix characters" do
        it "'kan'" do
          should_transform(:remove_suffix, 'katakan', 'kata')
        end

        it "'an'" do
          pending 'skip this for now'
          should_transform(:remove_suffix, 'sandaran', 'sandar')
        end

        it "'i'" do
          should_transform(:remove_suffix, 'tiduri', 'tidur')
        end
      end

      describe 'at the rest part of the word, should not remove the characters' do
        it "'kan'" do
          should_not_transform(:remove_suffix, 'kanxxx')
          should_not_transform(:remove_suffix, 'xxxkanxxx')
        end

        it "'an'" do
          should_not_transform(:remove_suffix, 'anxxx')
          should_not_transform(:remove_suffix, 'xxxanxxx')
        end

        it "'i'" do
          should_not_transform(:remove_suffix, 'ixxx')
          should_not_transform(:remove_suffix, 'xxxixxx')
        end
      end
    end
  end
end

def should_transform(method_name, word, transformed_word)
  IndonesianStemmer.send(method_name, word).should == transformed_word
end

def should_not_transform(method_name, word)
  IndonesianStemmer.send(method_name, word).should == word
end