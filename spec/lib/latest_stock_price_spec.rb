# spec/lib/latest_stock_price_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe LatestStockPrice, type: :lib do
  let(:base_url) { "https://latest-stock-price.p.rapidapi.com" }
  let(:headers) do
    {
      'X-RapidAPI-Key' => Rails.application.credentials.rapidapi.x_rapidapi_key.to_s ,
      'X-RapidAPI-Host' => Rails.application.credentials.rapidapi.x_rapidapi_host.to_s
    }
  end

  describe '.equities' do
    context 'when ISIN is provided' do
      it 'returns a valid response' do
        isin = 'US0378331005,US0231351067'
        stub_request(:get, "#{base_url}/equities")
          .with(headers: headers, query: { ISIN: isin })
          .to_return(status: 200, body: { data: 'valid response' }.to_json)

        response = LatestStockPrice::API.equities(ISIN: isin)
        expect(response).to eq("{\"data\":\"valid response\"}")
      end

      it 'raises an error for invalid ISIN' do
        expect {
          LatestStockPrice::API.equities(ISIN: 'INVALID_ISIN')
        }.to raise_error(ArgumentError, "Invalid ISIN format. It should be comma-separated valid ISIN codes.")
      end
    end

    context 'when OnlyIndex is true and Indicies are provided' do
      it 'validates and returns a response for valid indices' do
        indices = 'BANKNIFTY,CNX100'
        stub_request(:get, "#{base_url}/equities")
          .with(headers: headers, query: { OnlyIndex: true, Indicies: indices })
          .to_return(status: 200, body: { data: 'valid indices response' }.to_json)

        response = LatestStockPrice::API.equities(OnlyIndex: true, Indicies: indices)
        expect(response).to eq("{\"data\":\"valid indices response\"}")
      end

      it 'raises an error for invalid index codes' do
        expect {
          LatestStockPrice::API.equities(OnlyIndex: true, Indicies: 'INVALID_INDEX')
        }.to raise_error(ArgumentError, "Invalid index codes: INVALID_INDEX")
      end
    end

    context 'when OnlyIndex is true but Indicies are missing' do
      it 'raises an error' do
        expect {
          LatestStockPrice::API.equities(OnlyIndex: true)
        }.to raise_error(ArgumentError, "Indicies are required when OnlyIndex is true.")
      end
    end
  end
end
