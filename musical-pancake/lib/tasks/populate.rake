namespace :populate do
  desc "Import default regions"
  task :postal_code_cities => :environment do
    ActiveRecord::Base.transaction do
      PostalCodeCity.delete_all
      CSV.foreach("#{Rails.root}/db/seed_data/postal_code_city.csv", headers: false, col_sep: ';') do |row|
        row = row.map(&:strip)
        PostalCodeCity.create!(
          postal_number:    row[0],
          city:             row[1],
          type_pc:          row[2],
          lower_boundary:   row[3],
          upper_boundary:   row[4],
          source_timestamp: row[5].to_date
        )
      end
    end
  end

  task :city_street_postal_codes => :environment do
    ActiveRecord::Base.transaction do
      CityStreetPostalCode.delete_all
      CSV.foreach("#{Rails.root}/db/seed_data/city_street_postal_codes.csv", headers: true) do |row|
        CityStreetPostalCode.create!(row.to_hash)
      end
    end
  end

  task :streets => :environment do
    cols_to_save_names = %i[number name name_upper_case mot_tri indic_lieu_dit]
    cols_to_save       = [0, 1, 2, 3, 6]
    ActiveRecord::Base.transaction do
      Street.delete_all
      CSV.foreach("#{Rails.root}/db/seed_data/street_numbers_utf8.csv", headers: false, col_sep: ';') do |row|
        row = row.map(&:strip)
        attributes = cols_to_save_names.zip(cols_to_save.map { |n| row[n] }).to_h
        Street.create!(attributes)
      end
    end
  end

  task :buildings => :environment do
    cols_to_save_names = %i[internal_number number code_multiple postal_number_fk street_fk]
    cols_to_save       = [0, 1, 2, 6, 10]
    ActiveRecord::Base.transaction do
      Building.delete_all
      CSV.foreach("#{Rails.root}/db/seed_data/buildings.csv", headers: false, col_sep: ';') do |row|
        row = row.map(&:strip)
        attributes = cols_to_save_names.zip(cols_to_save.map { |n| row[n] }).to_h
        Building.create!(attributes)
      end
    end
  end

  task :communes => :environment do
    cols_to_save_names = %i[code name name_upper_case ds_timestamp_modif canto_code_fk letter_code]

    ActiveRecord::Base.transaction do
      Commune.delete_all
      CSV.foreach("#{Rails.root}/db/seed_data/communes_utf8.csv", headers: false, col_sep: ';') do |row|
        row = row.map(&:strip)

        attributes = cols_to_save_names.zip(row).to_h
        attributes[:ds_timestamp_modif] = attributes[:ds_timestamp_modif].to_date

        Commune.create!(attributes)
      end
    end
  end
end
