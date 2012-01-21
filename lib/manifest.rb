module Blag
  class Manifest
    def initialize &block
      @path = Blag.get(:manifest_path)
      if block_given?
        @infos = {:articles => {}}
        self.instance_eval(&block)
        persist!
      else
        @infos = YAML.parse(File.read(@path)).transform
      end
    end
  
    def add_article path
      metas = Article.new(path).meta
      @infos[:articles][slug(metas['title'])] = {
        :path => path.match(/#{BLAG_ROOT}(.*)/)[1],
        :date => metas['date']
      }
    end
  
    def slug title
      tmp = title.to_url
      while @infos[:articles].any?{|slug, title| slug == tmp}
        tmp = tmp.match(/--\d+/) ? tmp.next : tmp << "--1"
      end
      tmp
    end
  
    def persist!
      FileUtils.mkdir_p File.dirname(@path)
      File.open @path, "w" do |file|
        file.puts @infos.to_yaml
      end
    end
  
    def find args
      if args[:type] == :article
        find_articles args
      end
    end
  
    def find_articles args
      puts "Articles"
      return (@infos[:articles][args[:slug]] || {})[:path] unless args[:slug].empty?
      pdate = args[:date]
      puts args
      return @infos[:articles].select{|slug, metas|
        date = Date.parse(metas[:date])
        ['year', 'month', 'day'].all?{ |period|
          date.send(period) == args[period] || args[period].nil? || args[period].empty?
        }
      }.map{ |slug, metas|
        metas[:path]
      }
    end
  end
end