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
    product_keys = @redis.keys("#{@namespace}:*")
    out = Enumerator.new do |yielder|
      4000.times do |i|
        p i
        product_keys.each do |key|
          yielder << JSON.parse(@redis.get key)
        end
      end
      @finished = true
    end
    out
  end

  def work
    tsv_transform
  end

  def tsv_transform
    require 'csv'
    require 'aws-sdk'
    s3 = AWS::S3.new
    obj = s3.buckets['test-feed-gen'].objects['out/file.tsv']
    obj.write(estimated_content_length: 10000000) do |buffer, bytes|
      if (!@finished)
        string = CSV.generate_line(["id", "description"], col_sep: "\t" )
        buffer.write string
        p string
        products.each do |thing|
          string = CSV.generate_line([thing["id"], thing["description"]], col_sep: "\t")
          buffer.write string
          # p string
        end
        p bytes
      end
    end
  end

  def xsl_transform
    doc   = Nokogiri::XML(products.to_xml)
    xslt  = Nokogiri::XSLT(File.read('./googlefeed.xsl'))
    puts xslt.transform(doc)
  end

end
