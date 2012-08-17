require 'open-uri'
require 'singleton'
require 'yaml'

module Sdjreader
  class IndexReader

    LIVETIME = 15 * 60

    include Singleton

    def initialize
      @agent = Mechanize.new
      @tempfile = File.join(TEMP_DIR, "top_page")
    end

    def get (*args)
      target = args[0] ? URI.join(SITE_URI, args[0]) : SITE_URI
      force = args[1]
      n = nil
      if force || ! freshness?
        open(target) do |f|
          n = Nokogiri::HTML f.read
        end
        h =  n.search(".story a").map{ |g|
          {title: g.children[0].to_s , uri: g.attributes['href'].value}
        }

        open(@tempfile, 'w') do |f|
          f.write YAML.dump h
        end
      else
        open(@tempfile, 'r') do |f|
          n = (YAML.parse f.read).to_ruby rescue self.get(nil, true)
        end
      end

      return n
    end

    def uri2filename(path)
      path.gsub!(/https?:\/\//, '')
      path.gsub!('/',_)
      File.join(TEMP_DIR, path)
    end

    def get_haedline
      get(nil, false)
    end

    def freshness?
      return false unless (File.exists? @tempfile)
      lastupdate = File::stat(@tempfile).mtime
      elapsed_min = (Time.now - lastupdate).to_i
      elapsed_min < LIVETIME
    end

    def put
      self.get_haedline.each_with_index{ |c, i|
        puts "#{"%2d" % (i + 1)} #{c[:title]}"
      }
    end

  end
end
