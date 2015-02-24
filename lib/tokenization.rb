module Tokenization 
  DEFAULT_REMOVE_CHARS = /<.*>|[[:punct:]\n]|/
  class Basic 
    attr_accessor :options 
    def initialize(target, options={delimiter: / /, remove: DEFAULT_REMOVE_CHARS})
      @target = target 
      @options = options 
    end 

    def words 
      @target
      .gsub(@options[:remove], '')
      .downcase 
      .split(@options[:delimiter])
    end 

  end 

  class Ngram
    attr_accessor :options
 
    def initialize(target, options = { regex: / / })
      @target = target
      @options = options
    end
 
    def ngrams(n)
      @target.split(@options[:regex]).each_cons(n).to_a
    end
 
    def unigrams
      ngrams(1)
    end
 
    def bigrams
      ngrams(2)
    end
 
    def trigrams
      ngrams(3)
    end
  end
end 