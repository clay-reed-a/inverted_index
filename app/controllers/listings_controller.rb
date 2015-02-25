class ListingsController < ApplicationController
  

  def search
    # god method 
    query_string = params[:q]
    words = query_string.downcase.split ' '

    word_models = words.map { |word| Word.find_by(content: word) }
    listings_for_words = word_models.map &:listings
    listings_with_all_words = listings_for_words.reduce &:&
    @listings = listings_with_all_words.uniq
    
    render :index 
  end

  def index
    @listings = Listing.all 
  end

  def show
    @listing = Listing.find(params[:id])
  end
end
