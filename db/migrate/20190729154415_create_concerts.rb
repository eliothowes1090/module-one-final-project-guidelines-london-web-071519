class CreateConcerts < ActiveRecord::Migration[5.0]
  def change
    create_table :concerts do |t|
      t.string :organisation
      t.string :venue
      t.string :artist
      t.integer :no_of_tickets
    end
  end
end
