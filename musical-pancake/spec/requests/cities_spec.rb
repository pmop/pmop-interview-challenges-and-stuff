require 'rails_helper'

RSpec.describe "/cities", type: :request do
  let!(:headers) do
    { "ACCEPT" => "application/json" }
  end

  describe "GET /:city/streets/" do
    let!(:city_street_postal_code) { Fabricate :city_street_postal_code }

    context 'with valid parameters' do
      it 'returns the correct json'do
        get "/cities/#{city_street_postal_code.city}/streets/", headers: headers

        expect(response).to have_http_status(:ok)

        response_json = JSON.parse(response.body)

        expect(response_json.first).to include(
          {
           'city'          => 'LUXEMBOURG',
           'street'        => 'WALDHAFF',
           'postal_code'   => '2712',
           'debut_tranche' => 'MyString',
           'fin_tranche'   => 'MyString',
           'paire_impaire' => 'p'
          }
        )
      end
    end
  end
end
