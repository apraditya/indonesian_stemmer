require 'indonesian_stemmer'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

def should_stem(word, expected_word)
  word.stem.should == expected_word
end

def should_transform(method_name, word, transformed_word)
  IndonesianStemmer.send(method_name, word).should == transformed_word
end

def should_not_transform(method_name, word)
  IndonesianStemmer.send(method_name, word).should == word
end

def should_set_flags_to(method_name, word, expected_constant)
  should_set_instance_variable_to(method_name,
                                  word,
                                  'flags',
                                  get_constant(expected_constant) )
end

def should_not_set_flags(method_name, word)
  should_not_set_instance_variable(method_name, word, 'flags')
end

def should_set_instance_variable_to(method_name, word, variable_name, expected_value)
  expect {
    IndonesianStemmer.send(method_name, word)
  }.to change {
      IndonesianStemmer.instance_variable_get("@#{variable_name}")
      }.to expected_value
end

def should_not_set_instance_variable(method_name, word, variable_name)
  expect {
    IndonesianStemmer.send(method_name, word)
  }.to_not change {
              IndonesianStemmer.instance_variable_get("@#{variable_name}") }
end

def get_constant(name, klass = IndonesianStemmer)
  klass.const_get name
end

def unset_flags
  IndonesianStemmer.instance_variable_set("@flags", nil)
end
