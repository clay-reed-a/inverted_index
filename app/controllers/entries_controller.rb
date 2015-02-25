class EntriesController < ApplicationController
  respond_to :json  

  def index
    @entries = Entry.all 
  end

  def show
    @entry = Entry.find(params[:id]) 
  end
end
