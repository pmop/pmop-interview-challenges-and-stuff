class CreatePostalCodeCities < ActiveRecord::Migration[6.1]
  def change
    create_table :postal_code_cities do |t|
      t.string :postal_number
      t.string :city
      t.string :type_pc
      t.integer :lower_boundary
      t.integer :upper_boundary
      t.date :source_timestamp

      t.timestamps
    end
  end
end
