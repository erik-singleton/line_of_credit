Rails.application.routes.draw do
  get '/' => 'homepage#index', as: :home

  get '/credit_lines' => 'credit_line#index', as: :credit_lines
  get '/credit_lines/:id' => 'credit_line#show', id: /[0-9]+/
  post '/credit_lines/interest_calculation' => 'credit_line#calculate_interest'
  post '/credit_lines' => 'credit_line#create'

  post '/transactions' => 'transaction#create'


  post '/user' => 'user#create'
  post '/login' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
end
