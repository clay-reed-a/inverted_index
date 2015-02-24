class Listing < ActiveRecord::Base
  include Tokenization  

  has_many :entries   
  has_many :words, through: :entries 

  after_create :index_listing 

  TOKENIZE_THESE_ATTRS =  [
    'title', 'summary'
  ]

  

  def self.update_from_feed(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    feed.entries.each do |entry|
      unless exists? :url => entry.url 
        create!(
          :publication_date => entry.published,
          :summary => entry.summary, 
          :url => entry.url,
          :title => entry.title 
          )
      end 
    end
  end

    private 

    def index_listing 
      TOKENIZE_THESE_ATTRS.each do |text_attr| 
        index_text(text_attr)    
      end 
    end 

    def index_text attr_name
      tokenized_attr = Tokenization::Basic.new(self[attr_name]) 
      words = tokenized_attr.words  

      words.each_with_index do |word, idx|

        unless Word.exists? :content => word 
          word_model = Word.create!(content: word)
        else
          word_model = Word.find_by(content: word)
        end 

        Entry.create!(
          listing_id: self.id, 
          word_id: word_model.id,
          section: attr_name,
          location: idx   
          )
      
      end 
    end 

end
