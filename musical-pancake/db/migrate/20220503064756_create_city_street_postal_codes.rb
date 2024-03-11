class CreateCityStreetPostalCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :city_street_postal_codes do |t|
      t.string :city
      t.string :street
      t.string :postal_code
      t.string :debut_tranche
      t.string :fin_tranche
      t.string :paire_impaire

      t.timestamps
    end
  end
end
