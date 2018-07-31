class GraphicsController < ApplicationController

  before_action :authenticate_user!

  protect_from_forgery except: :create

  def index
    @graphics = graphics
    render json: @graphics, status: :ok
  end

  def church_graphic
    @church_graphics = church_graphics
    render json: @church_graphics, status: :ok
  end

  def create
    graphic = Graphic.new(graphic: params[:attachment][:file],
                          graphic_name: params[:attachment][:graphic_name],
                          churches_id: current_user.church.id)

    if graphic.save
      render json: graphic, status: :ok
    else
      render json: graphic.errors, status: :internal_server_error
    end
  end

private

  def graphics
    # TODO: Should limit by church
    @graphics ||= Graphic.all
  end

  def church_graphics
    @church_graphics ||= graphics.
                         joins(:church).
                         where(churches: {slug: params[:id]})
  end

end
