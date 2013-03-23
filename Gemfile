source 'https://rubygems.org'

# Specify your gem's dependencies in indonesian_stemmer.gemspec
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. Remember to move these dependencies to your gemspec before
# releasing your gem to rubygems.org.

# To use in development
group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
  gem 'pry-debugger'

  if RbConfig::CONFIG['host_os'] =~ /darwin/
    gem 'growl'
    gem 'rb-fsevent', require: false
  end
end