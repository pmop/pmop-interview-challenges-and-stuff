class CreateBuildings < ActiveRecord::Migration[6.1]
  def change
    create_table :buildings do |t|
      t.integer :internal_number
      t.integer :number
      t.string :code_multiple
      t.string :postal_number_fk
      t.integer :street_fk

      t.timestamps
    end
  end
end
