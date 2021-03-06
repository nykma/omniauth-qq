# encoding: utf-8

require 'omniauth/strategies/oauth2'

# Refactoring is neeeded. This module should be unified with qq_mobile
module OmniAuth
  module Strategies
    class QQ < OmniAuth::Strategies::OAuth2
      option :name, "qq"

      option :client_options, {
        :site => 'https://graph.qq.com',
        :authorize_url => '/oauth2.0/authorize',
        :token_url => "/oauth2.0/token"
      }

      option :token_params, {
        :parse => :query
      }

      uid do
        @uid ||= begin
          access_token.options[:mode] = :query
          access_token.options[:param_name] = :access_token
          # Response Example: "callback( {\"client_id\":\"11111\",\"openid\":\"000000FFFF\"} );\n"
          response = access_token.get('/oauth2.0/me')
          #TODO handle error case
          matched = response.body.match(/"openid":"(?<openid>\w+)"/)
          matched[:openid]
        end
      end

      info do
        {
          :nickname => raw_info['nickname'],
          :name => raw_info['nickname'],
          :image => raw_info['figureurl_1'],
          :unionid => raw_info['unionid']
        }
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def raw_info
        @raw_info ||= begin
          #TODO handle error case
          #TODO make info request url configurable
          client.request(:get, "https://graph.qq.com/user/get_user_info", :params => {
              :format => :json,
              :openid => uid,
              :oauth_consumer_key => client.id,
              :access_token => access_token.token,
            }, :parse => :json).parsed
        end

        if options[:fetch_union_id]
          @raw_info['unionid'] ||= begin
            response = client.request(:get, "/oauth2.0/me", :params => {
                :format => :json,
                :access_token => access_token.token,
                :unionid => '1'
            })
            matched = response.body.match(/"unionid":"(?<unionid>\w+)"/)
            matched[:unionid]
          end
        end

        @raw_info
      end

      protected
      def build_access_token
        params = {
          'client_id' => client.id,
          'client_secret' => client.secret,
          'code' => request.params['code'],
          'grant_type' => 'authorization_code',
          'redirect_uri' => options[:redirect_uri]
        }.merge(token_params.to_hash(symbolize_keys: true))
        client.get_token(params, {:mode => :query})
      end
    end
  end
end

OmniAuth.config.add_camelization('qq', 'QQ')
