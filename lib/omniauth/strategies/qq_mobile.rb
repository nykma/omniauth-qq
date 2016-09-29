# encoding: utf-8

require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class QQMobile < OmniAuth::Strategies::OAuth2
      option :name, "qq_mobile"

      option :client_options, {
        :site => 'https://graph.qq.com/oauth2.0/',
        :authorize_url => '/oauth2.0/authorize',
        :token_url => "/oauth2.0/token"
      }

      option :token_params, {
        :state => 'foobar',
        :parse => :query
      }

      uid { request.params['openid'] }

      info do
        {
          :nickname => raw_info['nickname'],
          :name => raw_info['nickname'],
          :image => raw_info['figureurl_1'],
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
              :openid => request.params['openid'],
              :oauth_consumer_key => request.params['uid'],
              :access_token => access_token.token
            }, :parse => :json).parsed
        end
      end

      def callback_phase
          if !request.params['access_token'] || request.params['access_token'].to_s.empty?
              raise ArgumentError.new("No access token provided.")
          end

          self.access_token = build_access_token
          # Instead of calling super, duplicate the functionlity, but change the provider to 'weibo'.
          # This is done in order to preserve compatibilty with the regular weibo provider
          hash = auth_hash
          hash[:provider] = "qq_connect"
          self.env['omniauth.auth'] = hash
          call_app!

          rescue ::OAuth2::Error => e
          fail!(:invalid_credentials, e)
          rescue ::MultiJson::DecodeError => e
          fail!(:invalid_response, e)
          rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
          fail!(:timeout, e)
          rescue ::SocketError => e
          fail!(:failed_to_connect, e)
      end

      protected

      def build_access_token
          hash = request.params.slice("access_token","openid")
          ::OAuth2::AccessToken.from_hash(
            client,
            hash
          )
      end
    end
  end
end

OmniAuth.config.add_camelization('qq_mobile', 'QQMobile')
