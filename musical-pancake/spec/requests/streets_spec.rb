require 'rails_helper'

RSpec.describe "/streets", type: :request do
  let!(:headers) do
    { "ACCEPT" => "application/json" }
  end

  describe "GET /search" do
    before { Fabricate :city_street_postal_code }
    context 'with valid parameters' do
      it 'returns the correct json'do
        get '/streets/search', params: { city: 'LUXEMBOURG'}, headers: headers

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

  describe "GET /streets/:name/numbers/" do
    before { Fabricate :street }
    context 'with valid parameters' do
      it 'returns the correct json'do
        get "/streets/ALE%20WEE/numbers/", headers: headers

        expect(response).to have_http_status(:ok)

        response_json = JSON.parse(response.body)

        expect(response_json.first).to include(
          {
            'number'          => 1,
            'name'            => 'Ale Wee',
            'name_upper_case' => 'ALE WEE',
            'mot_tri'         => 'ALE',
            'indic_lieu_dit'  => 'N',
          }
        )
      end
    end
  end
end
