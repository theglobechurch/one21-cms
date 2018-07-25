module Response
  def json_response(object, status = :ok, serializer = nil, **params)
    render json: object, status: status, serializer: serializer, params: params
  end
end
