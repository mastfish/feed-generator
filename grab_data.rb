require "redis"

class GrabData

  def initialize api
    @api = api
    @redis = Redis.new
  end

  def work
    products = @api.get_products
    @redis.pipelined do
      products.each do |product|
        @redis.set("product:#{product["id"]}", product.to_json)
      end
    end
  end
end
