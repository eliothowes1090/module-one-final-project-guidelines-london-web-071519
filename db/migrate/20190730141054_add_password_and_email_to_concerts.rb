class AddPasswordAndEmailToConcerts < ActiveRecord::Migration[5.0]
  def change
    add_column :concerts, :email, :string
    add_column :concerts, :password, :string
  end
end
