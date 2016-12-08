Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/slides', to: 'slides#index'
  get '/slides/select', to: 'slides#select', as: :select_slide
  get '/slides/:slide_name/(:slide_index)', to: 'slides#view', as: :view_slide
end
