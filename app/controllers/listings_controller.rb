class ListingsController < ApplicationController
  

  def search
    # god method 
    query_string = params[:q]
    words = query_string.downcase.split ' '

    word_models = words.map { |word| Word.find_by(content: word) }
    entries_for_words = word_models.map &:entries
    listings_for_words = entries_for_words.map { |entries|
      rank_results_by_frequency(entries)  
    }

    listings_with_all_words = listings_for_words.reduce &:&
    
    @listings = listings_with_all_words
    
    render :index 
  end

  def index
    @listings = Listing.all 
  end

  def show
    @listing = Listing.find(params[:id])
  end

    private 

    def rank_results_by_frequency entries
      # takes an array of Entries & 
      # returns an array of unique Listings, 
      # ordered by the number of 
      # Entries in the original array 
      # belonging to each Listing
    
      histogram = 
        entries.reduce(Hash.new(0)) { |hash, entry| 
          hash[entry.listing_id] += 1; hash
      }

      entries.sort_by { |entry|
        [histogram[entry.listing_id] * -1, entry]  
      }.map(&:listing).uniq 

    end 
end
