module IndonesianStemmer
  module IrregularWords
    SPECIAL_LETTERS = %w( K P N R )

    class << self

      private
        def load_words(filename, chopped = false)
          file = File.open path(filename), 'rb'
          contents = file.read.split("\n")
          file.close
          if chopped
            contents.map { |word| word[1..-1] }
          else
            contents
          end
        end

        def path(filename)
          path = File.join(
                      File.expand_path(File.dirname(__FILE__)),
                      'irregular_words', filename )
        end
    end

    SPECIAL_LETTERS.each do |letter|
      const_set("BEGINS_WITH_#{letter}", load_words("#{letter.downcase}.txt", true))
    end

    ENDS_WITH_I = load_words('akhiran-i.txt')

    ON_PREFIX_CHARACTERS = {
      'meng' => BEGINS_WITH_K,
      'peng' => BEGINS_WITH_K,
      'mem' => BEGINS_WITH_P,
      'pem' => BEGINS_WITH_P,
    }

    ENDS_WITH_COMMON_CHARACTERS = {
      'kah' => load_words('kah.txt'),
      'lah' => load_words('lah.txt'),
      'pun' => load_words('pun.txt'),
      'ku'  => load_words('ku.txt'),
      'mu'  => load_words('mu.txt'),
      'nya' => load_words('nya.txt'),
    }

    ENDS_WITH_SUFFIX_CHARACTERS = %w( majikan ) + # ENDS_WITH_KAN
                                  ENDS_WITH_I
  end
end
