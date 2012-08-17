module Sdjreader
  class Article
    def initialize(uri)
      @uri = article_uri uri
    end
    def get
      open(@uri) do |f|
        Nokogiri::HTML f.read
      end
    end
    def parse
      puts get.search("div.body .p p").to_a.join("\n\n")
    end
  end
end
