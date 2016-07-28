class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.references :account, foreign_key: true, index: true
      t.string :user_agent
      t.string :endpoint, null: false
      t.string :p256dh
      t.string :auth

      t.timestamps
    end
    add_index :devices, :endpoint, unique: true
  end
end
