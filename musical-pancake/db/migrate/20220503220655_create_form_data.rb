class CreateFormData < ActiveRecord::Migration[6.1]
  def change
    create_table :form_data do |t|
      t.integer :number
      t.string :street
      t.string :postal_code
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
