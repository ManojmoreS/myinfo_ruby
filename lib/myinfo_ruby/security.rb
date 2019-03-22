require 'openssl'
require 'rest-client'
require 'jose'
module MyinfoRuby
  module Security
    def create_token_request(token_url, code, redirect_url, client_id, client_secret, auth_level, realm, private_key)
      token_params = {
        grant_type: 'authorization_code',
        code: code,
        redirect_uri: redirect_url,
        client_id: client_id,
        client_secret: client_secret
      }
      token_header = {'Content-Type' => "application/x-www-form-urlencoded", 'Cache-Control' => "no-cache"}

      authorization_header = nil
      if auth_level == 'L2'
        authorization_header = generate_signature(token_url, token_params, 'POST', 'application/x-www-form-urlencoded', client_id, private_key, realm)

        token_header.merge!({"Authorization" => authorization_header})
      end
      token_response = RestClient.post(token_url, token_params, token_header)
      JSON.parse(token_response)
    end

    def get_personal_data(personal_url, uinfin, token_response, client_id, attributes, auth_level, realm, private_key)
      puts '------ Fetching personal data ------'
      parameters = {
        :client_id => client_id,
        :attributes => attributes
      }
      authorization_header = token_response['token_type']+' '+token_response['access_token']
      url = personal_url + "/" + uinfin + "/"

      if auth_level == 'L2'
        auth_header = generate_signature(url, parameters, 'GET', 'application/x-www-form-urlencoded', client_id, private_key, realm)

        authorization_header = auth_header+','+authorization_header
      end

      personal_header = {
        'Cache-Control' => "no-cache",
        :Authorization => authorization_header,
        :params => parameters
      }
      RestClient.get(url, personal_header)
    end

    # Verify JWS
    def verify_JWS(token_response, private_key)
      jwk = JOSE::JWK.from_pem_file(private_key)
      decoded_JWS = jwk.verify(token_response["access_token"])
      decoded = JSON.parse(decoded_JWS[1])
      logger.info "#{DateTime.now} : Fetch personal data for #{decoded['sub']} NRIC/FIN"
      decoded
    end

    # Decrypt JWE
    def decrypt_JWE_response(personal_data_response, private_key)
      jwk = JOSE::JWK.from_pem_file(private_key)
      decrypted_personal_data = jwk.block_decrypt(personal_data_response.body)
      logger.info "#{DateTime.now} : Successfully fetched personal data"
      JSON.parse(decrypted_personal_data[0])
    end

    private

    # Generate digital fingerprint
    def generate_signature(url, params, method, content_type, app_id, private_key, realm)
      url = url.gsub(".api.gov.sg", ".e.api.gov.sg");
      time_stamp = DateTime.now.strftime('%Q')
      nonce_value = time_stamp+'00'

      # Initialize header
      apex_headers = {
        "apex_l2_eg_app_id": app_id,
        "apex_l2_eg_nonce": nonce_value,
        "apex_l2_eg_signature_method": "SHA256withRSA",
        "apex_l2_eg_timestamp": time_stamp,
        "apex_l2_eg_version": "1.0"
      }

      if method == 'POST' && content_type!= "application/x-www-form-urlencoded"
        params = {}
      end

      # Construct baseString
      base_params =  apex_headers.merge(params).to_query
      baseString = URI.unescape(method + "&" + url + "&" + base_params)

      # Sign the baseString with private_key
      pkey = OpenSSL::PKey::RSA.new(File.read(private_key))
      digest = OpenSSL::Digest::SHA256.new
      digital_signature = Base64.strict_encode64(pkey.sign(digest, baseString))

      authorization_header = "Apex_l2_eg realm="+realm+",apex_l2_eg_timestamp="+time_stamp+
      ",apex_l2_eg_nonce="+nonce_value+",apex_l2_eg_app_id="+app_id+
      ",apex_l2_eg_signature_method=SHA256withRSA,apex_l2_eg_version=1.0,apex_l2_eg_signature="+digital_signature
    end
  end
end
