class Listing < ActiveRecord::Base
  has_many :entries 
  has_many :words, through: :entries 

  after_create :index_listing 

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
      ap "Dude, I'm totally tokening the listing!"
    end 

end
