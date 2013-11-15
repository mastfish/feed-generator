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
      100.times do
        product_keys.each do |key|
          yielder << JSON.parse(@redis.get key)
        end
      end
    end
    out
  end

  def work
    tsv_transform
    p 'upload start'
    upload
  end

  def upload
    s3 = AWS::S3.new
    file = File.open("out/file.tsv", 'r')
    obj = s3.buckets['test-feed-gen'].objects['out/file.tsv']
    obj.write(:content_length => file.size) do |buffer, bytes|
      buffer.write(file.read(bytes))
      # you could do some interesting things here to track progress
    end
    file.close
  end

  def tsv_transform
    require 'csv'

    CSV.open("out/file.tsv", "a",col_sep: "\t") do |csv|
      csv << ["id", "description"]
      products.each do |thing|
        csv << [thing["id"], thing["description"]]
      end
    end
  end

  def xsl_transform
    doc   = Nokogiri::XML(products.to_xml)
    xslt  = Nokogiri::XSLT(File.read('./googlefeed.xsl'))
    puts xslt.transform(doc)
  end

end
