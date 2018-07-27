class AddLogosToChurch < ActiveRecord::Migration[5.2]
  def change
    change_table :churches do |t|
      t.string :church_logo_uid, null: true
      t.string :church_logo_600_uid, null: true
      t.string :church_logo_sq_uid, null: true
      t.string :church_logo_sq_500_uid, null: true
      t.string :church_logo_sq_250_uid, null: true
    end
  end
end
