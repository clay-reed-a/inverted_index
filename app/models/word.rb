class Word < ActiveRecord::Base
  has_many :entries 
  has_many :listings, through: :entries 
end
