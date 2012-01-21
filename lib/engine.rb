module Blag
  class Engine    
    
    def initialize
      #@manifest = Manifest.new
    end
    
    def call env
      request = Rack::Request.new(env)
      status, headers, body = nil, nil, nil
      Routes.detect do |k, v|
        if (match = env['PATH_INFO'].match(v)) != nil
          status, headers, body = self.send(k, match)
        end
        status && headers && body
      end
      [200,{"Content-Type"=> "text/html"},["<h1>Hello, World!</h1>"]]
    end
    
    def manifest
      @manifest ||= Manifest.new
    end
    
    def articles match
      articles = manifest.find :type => :article, :date => match, :slug => match[:slug]
      puts [articles].flatten.length
    end
  end
end
    