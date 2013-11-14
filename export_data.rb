require 'json'
require 'redis'
require "nokogiri"
require 'active_support/core_ext/array/conversions'

class ExportData
  def initialize namespace
    @namespace = namespace
    @redis = Redis.new
  end

  def products
    products = []
    product_keys = @redis.keys("#{@namespace}:*")
    product_keys.each do |key|
      products.push JSON.parse(@redis.get key)
    end
    products
  end

  def work
    doc   = Nokogiri::XML(products.to_xml)
    # puts doc
    xslt  = Nokogiri::XSLT(File.read('./test.xsl'))
    # p
    puts xslt.transform(doc)

  end

end
