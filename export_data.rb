require 'json'
require 'redis'
require "nokogiri"
require 'active_support/core_ext/array/conversions'
require 'mustache'

class ExportData
  def initialize namespace
    @namespace = namespace
    @redis = Redis.new
    @finished = false
  end

  def products
    product_keys = @redis.keys("#{@namespace}:*")
    out = Enumerator.new do |yielder|
      1.times do |i|
        # p i
        product_keys.each do |key|
          yielder << JSON.parse(@redis.get key)
        end
      end
      @finished = true
    end
    out
  end

  def parse_tbl_file
    template = File.read("./test.csv.tbl")
    lines = template.split("\n")
    @header = lines[0]
    @row = lines[1]
  end

  def csv_get_header
    @header.split(',')
  end

  # Should return one of:
    # 'in stock'
    # 'available for order'
    # 'out of stock'
    # 'preorder'
  # TODO, detect pre-order stuff
  def availability item
    if (item["availability"] == "available")
      return 'in stock'
    end
    'out of stock'
  end

  def csv_get_row (item)
    variables = {product: item, image: item["images"].first, availability: availability(item), gps: item["gps"]}
    # binding.pry
    row = Mustache.render(@row, variables)
    row.split('|')
  end

  def work
    parse_tbl_file
    tsv_transform
  end

  def tsv_transform
    require 'csv'
    require 'aws-sdk'
    s3 = AWS::S3.new
    obj = s3.buckets['test-feed-gen'].objects['out/file.tsv']
    # TODO, swappable data destination
    obj.write(estimated_content_length: 10000000) do |buffer, bytes|
      if (!@finished)
        string = CSV.generate_line(csv_get_header, col_sep: "\t" )
        buffer.write string
        puts string
        products.each do |item|
          string = CSV.generate_line(csv_get_row(item), col_sep: "\t")
          buffer.write string
          puts string
        end
      end
    end
  end

  def xsl_transform
    doc   = Nokogiri::XML(products.to_xml)
    xslt  = Nokogiri::XSLT(File.read('./googlefeed.xsl'))
    puts xslt.transform(doc)
  end

end
