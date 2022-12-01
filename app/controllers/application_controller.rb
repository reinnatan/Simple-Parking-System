class ApplicationController < ActionController::API
  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decode = JsonWebToken.decode(header)
      render json: { message: "Hello World" }
    end
  end
end
