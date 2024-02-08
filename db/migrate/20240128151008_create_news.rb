class CreateNews < ActiveRecord::Migration[7.0]
  def change
    create_table :news do |t|
      t.string :title, null: false, index: { unique: true }
      t.text :body, null: false
      t.date :date
      t.string :source, null: false, index: { unique: true }
      t.text :header, null: false, index: { unique: true }
      t.string :image
      t.boolean :publish
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
