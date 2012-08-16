require 'open-uri'
require 'singleton'

module Sdjreader
  class IndexReader
    include Singleton

    def initialize
      @agent = Mechanize.new
    end

    def get (*args)
      target = args[0] ? URI.join(SITE_URI, args[0]) : SITE_URI
      open(target) do |f|
        Nokogiri::HTML f.read
      end
    end

    def uri2filename(path)
      path.gsub!(/https?:\/\//, '')
      path.gsub!('/',_)
      File.join(TEMP_DIR, path)
    end

    def get_haedline
      get.search(".story a").map{ |g|
        {title: g.children[0].to_s , uri: g.attributes['href'].value}
      }
    end

    def page
      self.get_haedline.each_with_index{ |c, i|
        puts "#{"%2d" % (i + 1)} #{c[:title]}"
      }
    end
  end
end
