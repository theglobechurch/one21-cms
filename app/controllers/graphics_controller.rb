class GraphicsController < ApplicationController
  protect_from_forgery except: :create

  def index
    @graphics = graphics
    render json: @graphics, status: 200
  end

  def church_graphic
    @church_graphics = church_graphics
    render json: @church_graphics, status: 200
  end

  def create
    graphic = Graphic.new(graphic: params[:attachment][:file],
                          graphic_name: params[:attachment][:graphic_name],
                          church: current_user.church)

    if graphic.save
      render json: graphic, status: 200
    else
      render json: graphic.errors, status: 500
    end
  end

private

  def graphics
    # Should limit by church
    @graphics ||= Graphic.all()
  end

  def church_graphics
    @church_graphics ||= graphics.joins(:church).
                                  where(churches: {
                                    slug: params[:id]
                                  })
  end

end
