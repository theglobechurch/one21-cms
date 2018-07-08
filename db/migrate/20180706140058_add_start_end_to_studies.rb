class AddStartEndToStudies < ActiveRecord::Migration[5.2]
  def change
    change_table :studies do |t|
      t.string :study_start
      t.string :study_end
    end
  end
end
