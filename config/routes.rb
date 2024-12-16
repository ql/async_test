Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "main" => "main#ordinary_load"
  get "sequential_io_load" => "main#sequential_io_load"
end
