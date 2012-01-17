require 'rack'
require 'rack/request'
require 'yaml'
require 'rdiscount'
require 'simple_router'
require './lib/article'

BLAG_ROOT = File.dirname(__FILE__)
$:.unshift BLAG_ROOT

module Blag
  
  Options = {
    :manifest_path  => "tmp/manifest.yml",
    :cache_control  => 3600,
    :articles_path  => "./articles/"
  }
  
  Routes = {
    :filing => %r{ /(?<filing> [\w]+)(/)?(?<year> [0-9]{4} )?(/)?(?<month> [0-9]{2})?(/)?(?<day> [0-9]{2})?(/)?(?<slug>.*)? }x
  }
  
  class Blag    
    def run!
      run self
    end
    
    def initialize &block
      Article::manifest!
      self.instance_eval(&block) if block_given?
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
    
    def filing match
      articles = Article.find :date => match, :filing => match[:filing], :slug => match[:slug]
      puts articles.inspect, match.inspect
    end
    
    def set key, value
      Options[key] = value
    end
  end
end
