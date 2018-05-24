module Response
  def json_response(object, status = :ok, serializer = nil)
    render json: object, status: status, serializer: serializer
  end
end
