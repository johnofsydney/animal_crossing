Rails.application.routes.draw do
  resources :breeds

  # to delete a single phot belonging to an animal
  delete '/animals/:animal_id/delete_photo/:photo_id' => 'animals#delete_photo'

  resources :photos
  resources :animals
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
