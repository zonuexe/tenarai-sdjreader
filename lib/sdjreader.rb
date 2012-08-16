require 'sdjreader/version'
require 'nokogiri'
require 'mechanize'
require 'uri'
require 'open-uri'

module Sdjreader
  SITE_URI = 'http://slashdot.jp/'
  TEMP_DIR = '/tmp/tenarai/sdj'
end

require 'sdjreader/core'
require 'sdjreader/index_reader'

core = Sdjreader::Core.instance
core.pre *ARGV
core.main

