require_relative 'security'

module MyinfoRuby
  class Client
    include MyinfoRuby::Security

    def initialize config
      # Token api url
      @token_url = config[:token_url]
      # Personal api url
      @personal_url = config[:personal_url]
      # authorization code
      @code = config[:code]
      @private_key = config[:private_key]
      @client_id = config[:client_id]
      @client_secret = config[:client_secret]
      # Attributes to be fetched from MyInfo
      @attributes = config[:attributes]
      @redirect_uri = config[:redirect_url]
      @realm = config[:realm]
      @auth_level = config[:auth_level]
    end

    def fetch_personal
      # ********* Access Token *********
		  token_response = create_token_request(@token_url, @code, @redirect_url, @client_id, @client_secret, @auth_level, @realm, @private_key)

      # ********* Verify JWS *********
      decoded_jws = verify_JWS(token_response, @private_key)

      # ********* Personal Data *********'
      personal_response = get_personal_data(@personal_url, decoded_jws['sub'], token_response, @client_id, @attributes, @auth_level, @realm, @private_key)
      if personal_response.code == 200
        personal_data = decrypt_JWE_response(personal_response, @private_key)
        personal_data['uinfin'] = decoded_jws['sub']
        personal_data
      else
        puts "#{personal_response.code} : Error occoured while Fetching data"
        personal_response
      end
    end
  end
end
