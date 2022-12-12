require "base64"
require "qrcode_pix_ruby"
require "json"

class TicketingController < ApplicationController
  before_action :authorize_request,
                except: %i[
                  generate_ticket
                  pay_ticket
                  update_vehicle_type
                  update_ticket_area
                  get_all_ticket
                ]

  def get_all_ticket
    tickets = Ticket.all()
    render json: { tickets: tickets }, status: :ok
  end

  def generate_ticket
    params = request.query_parameters
    vehicle_type = params["vehicle_type"]
    place_name = params["place_name"]

    if vehicle_type == nil || place_name == nil
      render json: {
               message: "needs param vehicle_type and place_name"
             },
             status: :not_found
    else
      if vehicle_type != "car" && vehicle_type != "motorcycle"
        render json: {
                 message: "param vehicle_type must be car or motorcycle"
               },
               status: :not_found
      elsif place_name == ""
        render json: {
                 message: "param place name must be filled"
               },
               status: :not_found
      else
        date_enter = Time.now
        oid = BSON::ObjectId.new
        qrcode = RQRCode::QRCode.new([{ data: oid.to_s, mode: :byte_8bit }])
        png =
          qrcode.as_png(
            bit_depth: 1,
            border_modules: 4,
            color_mode: ChunkyPNG::COLOR_GRAYSCALE,
            color: "black",
            file: nil,
            fill: "white",
            module_px_size: 6,
            resize_exactly_to: false,
            resize_gte_to: false,
            size: 120
          )

        # Base64.encode64(png.to_s)
        #IO.binwrite("/Users/reinhart/Documents/github-qrcode.png", png.to_s)

        ticket =
          Ticket.new(
            _id: oid,
            type: vehicle_type,
            ticket_place: place_name,
            date_entrance: date_enter,
            ticket_image: Base64.encode64(png.to_s)
          )
        is_save = ticket.save
        render json: {
                 parking_district: place_name,
                 ticket_id: oid.to_s,
                 date_enter: date_enter.strftime("%d-%m-%C"),
                 time_enter: date_enter.strftime("%H:%M:%S"),
                 qr_code: Base64.encode64(png.to_s)
               }
      end
    end
  end

  def pay_ticket
    data = ActiveSupport::JSON.decode(request.body.read)
    begin
      select_ticket = Ticket.find(data["id_ticket"])
      date_checkout = Time.now
      price_vehicle = 0
      if select_ticket.type == "motorcycle"
        price_vehicle = 2000
      else
        price_vehicle = 5000
      end

      price =
        ((date_checkout - select_ticket.date_entrance.to_time) / 1.hours).to_i *
          price_vehicle
      select_ticket.date_checkout = date_checkout
      select_ticket.price = price
      is_update = select_ticket.save
      render json: { message: "ticket berhasil dibayar" }, status: :ok
    rescue => e
      render json: { message: e.to_s }, status: :not_found
    end
  end

  def update_vehicle_type
    data = ActiveSupport::JSON.decode(request.body.read)
    if data["type"] != "car" && data["type"] != "motorcycle"
      render json: {
               message: "param vehicle_type must be car or motorcycle"
             },
             status: :not_found
    else
      begin
        select_ticket = Ticket.find(data["id_ticket"])
        select_ticket.type = data["type"]
        select_ticket.save
        render json: { message: "type ticket berhasil diupdate" }, status: :ok
      rescue StandardError => e
        render json: { message: e.to_s }, status: :not_found
      end
    end
  end

  def update_ticket_area
    data = ActiveSupport::JSON.decode(request.body.read)
    if data["place_name"] == ""
      render json: { message: "place name must be filled" }, status: :not_found
    elsif data["id_ticket"] == ""
      render json: { message: "id ticket must be filled" }, status: :not_found
    else
      begin
        select_ticket = Ticket.find(data["id_ticket"])
        select_ticket.ticket_place = data["place_name"]
        select_ticket.save
        render json: { message: "Area berhasil diupdate" }, status: :ok
      rescue StandardError => e
        render json: { message: e.to_s }, status: :not_found
      end
    end
  end
end
