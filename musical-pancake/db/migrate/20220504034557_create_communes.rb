class CreateCommunes < ActiveRecord::Migration[6.1]
  def change
    create_table :communes do |t|
      t.integer :code
      t.string :name
      t.string :name_upper_case
      t.date :ds_timestamp_modif
      t.integer :canto_code_fk
      t.string :letter_code

      t.timestamps
    end
  end
end
