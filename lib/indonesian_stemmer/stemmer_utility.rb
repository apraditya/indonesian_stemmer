module IndonesianStemmer
  module StemmerUtility

    def starts_with?(text, by_text_size, prefix)
      return false if prefix.size > by_text_size
      prefix.size.times do |i|
        return false if text[i] != prefix[i]
      end
      return true
    end

    def ends_with?(text, by_text_size, suffix)
      suffix_size = suffix.size
      return false if suffix_size > by_text_size
      suffix_size.times do |i|
        return false if text[0 - (suffix_size - i)] != suffix[i]
      end
      return true
    end
  end
end
