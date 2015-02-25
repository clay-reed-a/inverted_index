class ListingsController < ApplicationController
  def search
    # god method  
  end

  def index
    @listings = Listing.all 
  end

  def show
    @listing = Listing.find(params[:id])
  end
end
