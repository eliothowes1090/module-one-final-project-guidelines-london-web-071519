class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.float :price
      t.integer :concert_id
      t.integer :user_id
    end
  end
end
