Rails.application.routes.draw do

  root 'application#index'

  scope 'api' do

    get 'words' => 'words#index'
    get 'words/:id' => 'words#show'
    
    get 'entries' => 'entries#index'
    get 'entries/:id' => 'entries#show'

    get 'listings' => 'listings#index'
    get 'listings/:id' => 'listings#show', 
      constraints: { id: /\d+/ }
    get 'listings/s' => 'listings#search'

  end 
end
