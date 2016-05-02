require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class Dnevnik < OmniAuth::Strategies::OAuth2
      option :name, "dnevnik"

      option :client_options, {
        :site          => 'https://api.staging.dnevnik.ru',
        :authorize_url => 'https://login.staging.dnevnik.ru/oauth2',
        :token_url     => 'https://api.staging.dnevnik.ru/v1/authorizations'
      }

      # Use access token as a URL param, as specified in the Dnevnik API docs
      option :auth_token_params, {
        :mode          => :query
      }

      def authorize_params
        super.tap do |params|
          puts ">>>>>>>>>>>>>>>>>>>> authorize_params: #{params}"
          params[:scope] = 'avatar,fullname,birthday,age,roles,schools,edugroups,lessons,marks,eduworks,relatives,files,contacts,friends,groups,networks,events,wall,messages,emailaddress,sex,socialentitymembership'
          params[:client_id] = options.client_id
        end
      end

      def token_params
        username_password = options.client_secret + ":"
        super.tap do |params|
          puts ">>>>>>>>>>>>>>>>>>>> token_params: #{params}"
          params[:headers] = {'Authorization' => "Basic #{Base64.encode64(username_password)}"}
        end
      end



      uid{ raw_info['data']['id'] }

      info do
        { :user_type => raw_info['type'] }.merge! raw_info['data']
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end
    end
  end
end


# Registers a response parser to convert Dnevnik's camelCase response to underscore:
OAuth2::Response.register_parser(:camelcase_json, 'application/json') do |body|
  j = MultiJson.load(body)
  j.keys.map(&:underscore).zip(j.values).to_h
end
