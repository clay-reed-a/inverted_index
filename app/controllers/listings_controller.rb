class ListingsController < ApplicationController
  

  def search
    # god method 
    query_string = params[:q]
    binding.pry  
  end

  def index
    @listings = Listing.all 
  end

  def show
    @listing = Listing.find(params[:id])
  end
end
