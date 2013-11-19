require 'bigcommerce'
require 'pry'
require 'aws-sdk'
require './lib/grab_data'
require './lib/export_data'


api = Bigcommerce::Api.new({
    :store_url => "https://store-aq2mv9u0.bcapp.dev",
    :username  => "admin",
    :api_key   => "65ebd71ca13eb0c63d16fc5e0ce26119a003aea9"
})


AWS.config(
  :access_key_id => ENV["S3_KEY_ID"],
  :secret_access_key => ENV["S3_ACCESS_KEY"],
  :region => 'ap-southeast-2',
)

import = GrabData.new(api)
# import.work
export = ExportData.new("product")
export.work
