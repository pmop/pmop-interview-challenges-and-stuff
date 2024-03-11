class PostalCodesController < ApplicationController
  def search_cities
    postal_number = search_cities_params[:postal_code].strip
    wildcard_search = "#{postal_number}%"

    results = PostalCodeCity.where(postal_number: postal_number) if postal_number.length >= 4

    results = PostalCodeCity.where('postal_number LIKE :search', search: wildcard_search) if postal_number.length == 3

    results = results.pluck(:city).uniq.map { |n| { city: n } }

    respond_to do |format|
      format.json { render json: results }
    end
  end

  private

  def search_cities_params
    params.permit(:postal_code)
  end
end
