class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :name
      t.integer :age
      t.string :email
      t.string :password
    end
  end
end
