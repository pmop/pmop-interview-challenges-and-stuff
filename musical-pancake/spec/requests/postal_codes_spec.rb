require 'rails_helper'

RSpec.describe "PostalCodes", type: :request do
  let!(:headers) do
    { "ACCEPT" => "application/json" }
  end

  describe "GET /postal-codes/:postal_code/cities/" do
    let(:postal_code_city) { Fabricate :postal_code_city }
    before { Fabricate :postal_code_city }

    context 'with valid parameters' do
      it 'returns the correct json'do
        get "/postal-codes/#{postal_code_city.postal_number}/cities/", headers: headers

        expect(response).to have_http_status(:ok)

        response_json = JSON.parse(response.body)

        expect(response_json.first).to include(
          {
            'postal_number'   => '1009',
            'city'            => 'LUXEMBOURG',
            'type_pc'         => 'N',
            'lower_boundary'  => 0,
            'upper_boundary'  => 0,
            'source_timestamp'=> '2000-07-28',
          }
        )
      end
    end
  end
end
