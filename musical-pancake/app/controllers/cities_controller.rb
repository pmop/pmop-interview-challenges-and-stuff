class CitiesController < ApplicationController
  def streets
    respond_to do |format|
      format.json { render json: CityStreetPostalCode.where(street_params) }
    end
  end

  private

  def street_params
    params.permit(:city)
  end
end
