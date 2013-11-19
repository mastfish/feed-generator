require "redis"
require 'net/http'
require 'json'

class GrabData

  def initialize api
    @api = api
    @redis = Redis.new
  end

  def work
    grab_products
  end

  def grab_products
    products = @api.products
    @redis.pipelined do
      products.each do |product|
        product.load(:brand, :images)
        uri = URI.parse @api.connection.configuration[:store_url]
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        res = http.get("/api/catalog/feeds/google?ids=#{product["id"]}")
        gps = JSON.parse(res.body)
        thing = JSON.parse(product.to_json)
        thing["gps"] = gps.first
        @redis.set("product:#{product["id"]}", thing.to_json)
      end
    end
  end

end
