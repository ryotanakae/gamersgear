class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.decimal :star, precision: 2, scale: 1, null: false, default: 0.0
      

      t.timestamps
    end
  end
end
