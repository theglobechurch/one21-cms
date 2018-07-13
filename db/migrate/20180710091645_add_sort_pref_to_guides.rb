class AddSortPrefToGuides < ActiveRecord::Migration[5.2]
  def change
    change_table :guides do |t|
      t.integer :sorting, null: false, default: 0
    end

    change_table :studies do |t|
      t.remove :published_dt
      t.datetime :published_at
    end

  end
end
