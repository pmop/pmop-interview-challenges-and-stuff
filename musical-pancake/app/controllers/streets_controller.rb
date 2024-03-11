class StreetsController < ApplicationController
  def numbers
    respond_to do |format|
      format.json { render json: Street.where(number_params) }
    end
  end

  def search
    respond_to do |format|
      format.json { render json: CityStreetPostalCode.where(street_params) }
    end
  end

  private

  def number_params
    params.permit(:name_upper_case)
  end

  def street_params
    params.permit(:city, :street, :postal_code)
  end
end
