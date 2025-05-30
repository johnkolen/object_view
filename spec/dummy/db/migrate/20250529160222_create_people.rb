class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :name
      t.date :date_of_birth
      t.string :ssn
      t.integer :age
      t.boolean :happy
      t.timestamps
    end
  end
end
