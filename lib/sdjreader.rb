require "sdjreader/version"
require 'nokogiri'
require 'mechanize'
require 'uri'
require 'optparse'
require 'singleton'
require 'open-uri'

module Sdjreader
  SITE_URI = 'http://slashdot.jp/'
  TEMP_DIR = '/tmp/tenarai/sdj'
  class Core
    include Singleton
    def initialize
      @config = Hash.new
      @index = IndexReader.instance
      @parser = OptionParser.new("/.J Reader - #{VERSION}")
      @parser.on("-h", "--help"){ @config[:help] = true }
      @parser.on("-v", "--version"){ @config[:version] = true }
    end

    def main
      if @config[:null]
        @index.page
      end
    end

    def optparse(*args)
      @config[:noargs] = true && return if args.size == 0
      @parser.parse! args
      @config[:rest] = args
    end

    def setup
      Dir.mkdir TEMP_DIR unless Dir.exists? TEMP_DIR
    end

    def pre(*args)
      config = self.optparse(*args)
      self.help if @config[:help]
      self.version if @config[:version]
    end

    def help
      puts @parser
      exit 1
    end
  end

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
      get.search(".story a").map{|g| {title: g.children[0].to_s , uri: g.attributes['href'].value}}
    end

    def page
      IndexReader.new.get_haedline.each_with_index{ |c, i|
        puts "#{"%2d" % (i + 1)} #{c[:title]}"
      }
    end
  end
end

core = Sdjreader::Core.instance
core.pre *ARGV
core.main

