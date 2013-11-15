require 'bigcommerce'
require 'pry'
require 'aws-sdk'
require './grab_data'
require './export_data'


api = Bigcommerce::Api.new({
    :store_url => "https://store-gt1zgky4.bcapp.dev",
    :username  => "admin",
    :api_key   => "1320fd79b5b47c8173d642e33879002ffb1c7ff2"
})


AWS.config(
  :access_key_id => ENV["S3_KEY_ID"],
  :secret_access_key => ENV["S3_ACCESS_KEY"]
)

import = GrabData.new(api)
# import.work
export = ExportData.new("product")
export.work
