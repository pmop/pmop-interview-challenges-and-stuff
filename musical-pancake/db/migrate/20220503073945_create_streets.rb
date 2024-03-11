class CreateStreets < ActiveRecord::Migration[6.1]
  def change
    create_table :streets do |t|
      t.integer :number
      t.string :name
      t.string :name_upper_case
      t.string :mot_tri
      t.string :indic_lieu_dit

      t.timestamps
    end
  end
end
