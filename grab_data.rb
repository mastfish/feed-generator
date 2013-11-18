require "redis"

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
        @redis.set("product:#{product["id"]}", product.to_json)
      end
    end
  end

end
