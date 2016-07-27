class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :pin

      t.timestamps
    end
    add_index :accounts, :pin, unique: true
  end
end
