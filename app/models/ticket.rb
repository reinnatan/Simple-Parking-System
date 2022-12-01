class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  field :id, type: String
  field :date_entrance, type: String
  field :date_checkout, type: String
  field :price, type: Integer
  field :type, type: String
  field :ticket_place, type: String
  field :ticket_image, type: String
end
