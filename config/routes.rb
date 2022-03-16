Rails.application.routes.draw do
  resources :breeds

  # to delete a single phot belonging to an animal
  delete '/animals/:animal_id/delete_photo/:photo_id' => 'animals#delete_photo'


  get '/animals/dogs' => 'animals#dogs'
  get '/animals/cats' => 'animals#cats'
  get '/animals/others' => 'animals#others'
  get '/animals/adopted' => 'animals#adopted'

  resources :photos
  resources :animals
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#home"
end


# http://localhost:3000/rails/info/routes
# http://localhost:3000/rails/info/properties