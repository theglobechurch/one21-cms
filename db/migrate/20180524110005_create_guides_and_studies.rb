class CreateGuidesAndStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :guides do |t|
      t.string :guide_name, null: false, default: ""
      t.string :slug, null: false, default: ""
      t.string :teaser
      t.string :description
      t.string :copyright
      t.boolean :highlight_first, null: false, default: false

      t.timestamps null: false
    end

    create_join_table :guides, :churches, table_name: :church_guides do |t|
      t.boolean :promoted, null: false, default: false
      t.boolean :owner, null: false, default: false
      t.index :church_id
      t.index :guide_id
      t.index :promoted
    end

    create_table :studies do |t|
      t.references :guides, foreign_key: true, index: true

      t.datetime :published_dt, limit: 6
      t.integer  :status

      t.string :study_name, null: false, default: ""
      t.string :slug, null: false, default: ""
      t.string :description

      t.integer :sort_order, null: false, default: 0

      t.string :recording_url
      t.string :website_url

      t.jsonb :passage_ref
      t.jsonb :questions, null: false, default: ""

      t.timestamps null: false
    end
  end
end
