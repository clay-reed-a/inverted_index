class Entry < ActiveRecord::Base
  has_one :word
  has_one :listing 
end
