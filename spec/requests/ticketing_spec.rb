require "swagger_helper"

RSpec.describe "ticketing", type: :request do
  path "/get-ticket" do
    get("generate_ticket ticketing") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path "/pay-ticket" do
    post("pay_ticket ticketing") do
      parameter name: :id_ticket,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    id_ticket: {
                      type: :string
                    }
                  },
                  required: %w[id_ticket]
                }

      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path "/update-vehicle-type" do
    put("update_vehicle_type ticketing") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path "/update-ticket-area" do
    put("update_ticket_area ticketing") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
