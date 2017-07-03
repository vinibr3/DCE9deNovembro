class AddLayoutToEstudantes < ActiveRecord::Migration
  def change
    add_column :estudantes, :layout, :integer, defaut: 0
  end
end
