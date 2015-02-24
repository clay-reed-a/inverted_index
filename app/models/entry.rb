class Entry < ActiveRecord::Base
  belongs_to :word
  belongs_to :listing 
end
