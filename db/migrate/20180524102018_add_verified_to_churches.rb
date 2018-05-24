class AddVerifiedToChurches < ActiveRecord::Migration[5.2]
  def up
    add_column :churches, :verified, :boolean, null: false, default: false
    add_index :churches, :verified
  end

  def down
    remove_column :churches, :verified
  end
end
