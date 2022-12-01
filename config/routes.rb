Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # Routing for generate and update ticket data
  get "/get-ticket", to: "ticketing#generate_ticket"
  post "/pay-ticket", to: "ticketing#pay_ticket"
  put "/update-vehicle-type", to: "ticketing#update_vehicle_type"
  put "/update-ticket-area", to: "ticketing#update_ticket_area"

  # Routing for generate report
  post "/report-areas", to: "report_parking_system#report_areas"
  post "/report-all-areas", to: "report_parking_system#report_all_areas"
end
