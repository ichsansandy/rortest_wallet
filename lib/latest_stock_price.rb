require 'httparty'
require_relative 'latest_stock_price/version'

module LatestStockPrice
  class API
    BASE_URL = 'https://latest-stock-price.p.rapidapi.com'
    API_KEY = Rails.application.credentials.rapidapi.x_rapidapi_key.to_s 
    API_HOST = Rails.application.credentials.rapidapi.x_rapidapi_host.to_s
    INDEX_CODES = %w[
    BANKNIFTY CNX100 CNX200 CNX500 CNXALPHA CNXAUTO CNXCOMMO CNXCONSM
    CNXDEFTY CNXDIVOPT CNXENER CNXFIN CNXFMCG CNXHIGH CNXINFRA CNXIT CNXLOW
    CNXLOWV30 CNXMCAP CNXMEDIA CNXMETAL CNXMNC CNXNFTYJUN CNXPHAR CNXPSE
    CNXPSU CNXREALTY CNXSCAP CNXSERV CPSE INDIAVIX LIX15 LIX15MCAP LRGMID250
    NI15 NIFADIBIR NIFESG NIFFINEX NIFFINSE NIFIND NIFMAHI NIFMIC NIFMIDS
    NIFMIDSE NIFMOM NIFMUL NIFREIN NIFSMQUA NIFTALPF NIFTATGRO NIFTATGRO25PC
    NIFTCOHOUS NIFTDEFE NIFTHOUS NIFTMANU NIFTMFIN NIFTMHEA NIFTMIT NIFTMOBI
    NIFTMOME NIFTNON NIFTPR1X NIFTPR2X NIFTRA NIFTTOTA NIFTTR1X NIFTTR2X
    NIFTY NIFTY100EQW NIFTY100ESG NIFTY200QUA NIFTY500VAL NIFTYALP
    NIFTYALPHQUAL NIFTYALPHVOLT30 NIFTYCON NIFTYDIV NIFTYEQUWEI NIFTYM150
    NIFTYM50 NIFTYMIDQUA NIFTYMSC400 NIFTYOIL NIFTYPVTBANK NIFTYQUALVOLT30
    NIFTYSCAP250 NIFTYSCAP50 NIFTYSME NIFTYVALUEVOLT30 NSEHCARE NSEQ30 NV20
  ].freeze



    def self.equities_search(symbol_param)
      response = HTTParty.get("#{BASE_URL}/equities-search", {
        headers: headers,
        query: { Search: symbol_param }
      })
      parse_response(response)
    end

    def self.equities_enhanced(symbols)
      response = HTTParty.get("#{BASE_URL}/equities-enhanced", {
        headers: headers,
        query: { Symbols: symbols.join(',') }
      })
      parse_response(response)
    end

    def self.equities(params)
      # Optional ISIN validation (comma separated)
      if params[:ISIN].present?
        isins = params[:ISIN].split(',')
        unless isins.all? { |isin| isin.match?(/\A[A-Z0-9]+\z/) }
          raise ArgumentError, "Invalid ISIN format. It should be comma-separated valid ISIN codes."
        end
      end

      # OnlyIndex validation (boolean)
      if params[:OnlyIndex].present?
        only_index = ActiveModel::Type::Boolean.new.cast(params[:OnlyIndex])
        
        if only_index
          # Indicies are required if OnlyIndex is true
          if params[:Indicies].blank?
            raise ArgumentError, "Indicies are required when OnlyIndex is true."
          end

          # Validate Indicies (comma-separated, predefined values)
          indicies = params[:Indicies].split(',')
          invalid_indicies = indicies - INDEX_CODES

          if invalid_indicies.any?
            raise ArgumentError, "Invalid index codes: #{invalid_indicies.join(', ')}"
          end
        end
      end

      # Proceed with the API request after validation
      response = HTTParty.get("#{BASE_URL}/equities", {
        headers: headers,
        query: params.slice(:ISIN, :OnlyIndex, :Indicies) # Pass valid params to the API
      })

      parse_response(response)
    end

    private

    def self.headers
      {
        'X-RapidAPI-Key' => API_KEY,
        'X-RapidAPI-Host' => 'latest-stock-price.p.rapidapi.com'
      }
    end

    def self.parse_response(response)
      if response.success?
        response.parsed_response
      else
        { error: response.message }
      end
    end
  end
end
