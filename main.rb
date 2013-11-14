require 'bigcommerce'
require 'pry'

api = Bigcommerce::Api.new({
    :store_url => "https://store-gt1zgky4.bcapp.dev",
    :username  => "admin",
    :api_key   => "1320fd79b5b47c8173d642e33879002ffb1c7ff2"
})
binding.pry
