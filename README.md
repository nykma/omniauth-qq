# Omniauth QQ

This is QQ strategies collection for OmniAuth 2.0, which includes QQ web and QQ mobile.
  
## [QQ-MOBILE QQ](http://connect.qq.com/intro/login/) OAuth2
  Strategy from https://github.com/kaichen/omniauth-qq-connect, credit go to Kai Chen.

## Installation

Add to your `Gemfile`:

```ruby
gem 'omniauth-qq'
```

Then `bundle install`.

Or install it yourself as:

    $ gem install omniauth-qq

## Usage

`OmniAuth::Strategies::Qq` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :qq, ENV['QQ_KEY'], ENV['QQ_SECRET']
  provider :qq_mobile, ENV['QQ_MOBILE_KEY'], ENV['QQ_MOBILE_SECRET']
end
```

## Authentication Hash

Here's an example *Authentication Hash* available in `request.env['omniauth.auth']`:



### QQ-MOBILE and QQ returns:

```ruby
{
  :provider => 'qq_connect',
  :uid => 'B11630C4...', # QQ call it openid
  :info => {
    :nickname => 'beenhero',
    :image => 'http://qzapp.qlogo.cn/qzapp/100250034/B11630C4AAC8C17B57ECFEA80852C813/50',
    # so little info !? I think so, QQ-Connect only provides so, you can check from the raw_info below. Or you can try TQQ instead :)
  },
  :credentials => {
    :token => '2.00JjgzmBd7F...', # OAuth 2.0 access_token, which you may wish to store
    :expires_at => 1331780640, # when the access token expires (if it expires)
    :expires => true # if you request `offline_access` this will be false
  },
  :extra => {
    :raw_info => {
      ... # little info from https://graph.qq.com/user/get_user_info
    }
  }
}
```

*PS.* Built and tested on MRI Ruby 1.9.3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## problem fixed

The problem is QQ web returning text/plain for the content-type header when it should be application/x-www-form-urlencoded

## License

Copyright (c) 2012 by Bin He

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.