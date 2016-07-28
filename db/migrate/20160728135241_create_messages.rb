class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :title
      t.text :body
      t.references :account, foreign_key: true, index: true

      t.timestamps
    end
  end
end
