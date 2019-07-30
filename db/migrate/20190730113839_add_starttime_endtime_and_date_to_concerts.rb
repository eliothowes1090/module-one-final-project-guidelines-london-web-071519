class AddStarttimeEndtimeAndDateToConcerts < ActiveRecord::Migration[5.0]
  def change
    add_column :concerts, :start_time, :string
    add_column :concerts, :end_time, :string
  end
end
