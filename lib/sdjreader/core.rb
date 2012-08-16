require 'optparse'
require 'singleton'

module Sdjreader
  class Core
    include Singleton
    def initialize
      @config = Hash.new
      @index = IndexReader.instance
      @parser = OptionParser.new(HEADER)
      @parser.on("-h", "--help"){ @config[:help] = true }
      @parser.on("-v", "--version"){ @config[:version] = true }
    end

    def main
      @config
      if @config[:noargs]
        @index.page
      end
    end

    def optparse(*args)
      (@config[:noargs] = true) && return if args.size == 0
      @parser.parse! args
      @config[:rest] = args
      @config
    end

    def setup
      Dir.mkdir TEMP_DIR unless Dir.exists? TEMP_DIR
    end

    def pre(*args)
      self.optparse(*args)
      self.help if @config[:help]
      self.version if @config[:version]
    end

    def help
      puts @parser
      exit 1
    end

    def version
      puts HEADER
    end

  end
end
