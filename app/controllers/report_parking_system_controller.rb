class ReportParkingSystemController < ApplicationController
  def report_areas
    listTicket = Ticket.where(ticket_place: "PIK")
    render json: { message: "success", result: listTicket }, status: :ok
  end

  def report_all_areas
    @listTicket = Ticket.collection.aggregate([{"$group" : {"_id" : {"ticket_place" : "$ticket_place"},"SUM(price)" : {"$sum" : "$price"}}},{"$project" : {"ticket_place" : "$_id.ticket_place","SUM(price)" : "$SUM(price)","_id" : NumberInt(0)}}],{"allowDiskUse" : true})
    render json: { message: "success", result: listTicket }, status: :ok
  end

end
