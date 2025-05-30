class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password, null: false, default: ""
      t.references :person, null: true# , foreign_key: true
      t.integer :role_id, null: false, default: 0

      t.timestamps
    end
  end
end
