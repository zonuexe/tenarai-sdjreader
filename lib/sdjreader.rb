require 'sdjreader/version'
require 'nokogiri'
require 'mechanize'
require 'uri'


module Sdjreader
  SITE_URI = 'http://slashdot.jp/'
  TEMP_DIR = '/tmp/tenarai/sdj'

  def self.version
    puts HEADER
  end

  def self.article_uri(uri)
    uri =~ RE_ARTICLE_URI
    $1
  end

end

require 'sdjreader/core'
require 'sdjreader/index_reader'

core = Sdjreader::Core.instance
core.pre *ARGV
core.main

