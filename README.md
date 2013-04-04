# IndonesianStemmer

[![Gem Version](https://badge.fury.io/rb/indonesian_stemmer.png)](http://badge.fury.io/rb/indonesian_stemmer)
[![Build Status](https://secure.travis-ci.org/apraditya/indonesian_stemmer.png)](http://travis-ci.org/apraditya/indonesian_stemmer)
[![Dependency Status](https://gemnasium.com/apraditya/indonesian_stemmer.png)](https://gemnasium.com/apraditya/indonesian_stemmer)
[![Code Climate](https://codeclimate.com/github/apraditya/indonesian_stemmer.png)](https://codeclimate.com/github/apraditya/indonesian_stemmer)



Stems Indonesian words based on Porter Stemmer, with the algorithm presented in [**A Study of Stemming Effects on Information Retrieval in Bahasa Indonesia**](http://www.illc.uva.nl/Publications/ResearchReports/MoL-2003-02.text.pdf), by Fadillah Z Tala.

## Installation

Add this line to your application's Gemfile:

    gem 'indonesian_stemmer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install indonesian_stemmer

## Usage

    require 'rubygems'
    require 'indonesian_stemmer'

    IndonesianStemmer.stem('mendengarkan')  # => "dengar"
    'beriman'.stem                          # => "iman"

## Known Problems
This gem is in active development, don't rely on this for your analysis or datamining projects. Currently there's no problems stemming Indonesian words. Please [submit a ticket](https://github.com/apraditya/indonesian_stemmer/issues/new) if you find one.


## Contributing
Initially, this gem is based on [Apache Lucene](http://lucene.apache.org/). Currently it's just a ruby port from its analyzer for Indonesian. Its stemmer library only analyze the word length, therefore some modifications added in order to get the actual stemmed word. Feel free to download Lucene's source code under `analysis/common/src/java/org/apache/lucene/analysis/id/`.

### References
Some references to help your contribution:

1. [The Official Kamus Bahasa Indonesia](http://bahasa.kemdiknas.go.id/kbbi/index.php)
2. To search Indonesian words and their roots, use the [Unofficial Kamus Besar Bahasa Indonesia](http://www.kamusbesar.com/)
3. Wikipedia's [Prefiks dalam Bahasa Indonesia](http://id.wikipedia.org/wiki/Prefiks_dalam_bahasa_Indonesia) 


### Steps

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
