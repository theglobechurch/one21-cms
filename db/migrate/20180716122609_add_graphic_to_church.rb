class AddGraphicToChurch < ActiveRecord::Migration[5.2]
  def change
    add_reference :churches, :graphics, index: true
  end
end
