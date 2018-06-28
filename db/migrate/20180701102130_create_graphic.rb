class CreateGraphic < ActiveRecord::Migration[5.2]
  def change
    create_table :graphics do |t|
      t.belongs_to :churches, index: true
      t.string :graphic_name
      t.string :graphic_uid
      t.string :graphic_thumbnail_uid
      t.string :graphic_thumbnail_2x_uid
      [320, 640, 960, 1280, 1920, 2560].each do |size|
        t.string :"graphic_#{size}_uid"
      end
      t.timestamps
    end

    add_reference :guides, :graphics, index: true
    add_reference :studies, :graphics, index: true

    # add_foreign_key :guides, :graphics, column: :graphics_id
    # add_foreign_key :studies, :graphics, column: :graphics_id
  end
end
