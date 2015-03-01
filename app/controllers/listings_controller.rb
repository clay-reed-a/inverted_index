class ListingsController < ApplicationController
  
  # this is a god method,
  # please split until no scrolling is necessary  
  def search
    
    query = process_query_str 
    words = query[:words] 
    query_phrase = query[:query_phrase] 



    # ignore multiple query phrases for now 
   
    if query_phrase

      query_phrase_words = 
        query_phrase
          .remove(/[[:punct:]]/)
          .split

      query_phrase_first_word = Word.find_by(
        content: 
          query_phrase_words
            .first
      ) 

      query_phrase_first_word_entries = 
        query_phrase_first_word.entries 

      query_phrase_other_words = 
        query_phrase_words
          .last(query_phrase_words.length-1)
            .map { |word_str|
              Word.find_by(content: 
                word_str
              ) 
            }  

      query_phrase_results = 
        query_phrase_first_word_entries
          .select { |entry|

            next_location = entry.location 
            same_section = entry.section 
            same_listing = entry.listing_id

            query_phrase_other_words
              .all? { |other_word|
            
                next_location += 1 
            
                entries = Entry.where(
                  word_id: other_word.id,
               listing_id: same_listing, 
                 location: next_location,
                  section: same_section
                ) 
            
                entries.any? 
              }
          }
          unless words 
            @listings = query_phrase_results.map(&:listing) 
          end 
      end 
    
    if words 
      word_models = words.map { |word| Word.find_by(content: word) }

      # if any are nil, we know an empty array would result 
      render(json: []) and return unless word_models.all? 

      entries_for_words = word_models.map &:entries 

      listings_for_words = entries_for_words.map { |entries|
        rank_results_by_frequency(entries)  
      }

      listings_for_words << query_phrase_results.map(&:listing) if query_phrase 

      listings_with_all_words = listings_for_words.reduce &:&
    
      @listings = listings_with_all_words 
    end        

    
    
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

      private 

      def process_query_str 
        query = {}
        query_str = params[:q].downcase

        query_phrases = 
          query_phrases!(query_str)
        query_words = 
          query_str.remove(/[[:punct:]]/).split

        query[:query_phrase] = 
          query_phrases.length.zero? ? false : query_phrases.first 
        query[:words] = 
          query_words.length.zero? ? false : query_words 
           
        query   
      end 

      def each_slice! str, regex    
        substrs = []

        while substr = str.slice!(regex) 
          substrs << substr 
        end 

        substrs 
      end 

      def query_phrases! query_str 
        each_slice! query_str, /"([^\"]*)"/
      end 
end
