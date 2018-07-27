module Response
  def json_response(object, status = :ok, serializer = nil, **params)
    default_params = {
      base_url: base_url
    }
    
    render json: object,
           status: status,
           serializer: serializer,
           params: default_params.merge(params)
  end

  def base_url
    request.base_url
  end
end
