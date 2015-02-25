class Word < ActiveRecord::Base
  has_many :entries 
  has_many :listings, through: :entries 

  def uniq_listings # hack 
    self.listings.uniq 
  end 
end
