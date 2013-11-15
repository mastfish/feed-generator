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



import = GrabData.new(api)
# import.work
export = ExportData.new("product")
export.work
