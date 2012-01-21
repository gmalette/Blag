BLAG_ROOT = File.dirname(__FILE__)
$:.unshift BLAG_ROOT

%w(rack rack/request yaml rdiscount date lib/article lib/manifest lib/engine stringex).each do |req|
  require req
end


module Blag
  
  Options = {
    :manifest_path  => "config/manifest.yml",
    :cache_control  => 3600,
    :articles_path  => "./articles/"
  }
  
  Routes = {
    :filing => %r{ /(?<filing> [\w]+)(/)?(?<year> [0-9]{4} )?(/)?(?<month> [0-9]{2})?(/)?(?<day> [0-9]{2})?(/)?(?<slug>.*)? }x
  }
  
  def self.configure &block
    self.instance_eval(&block) if block_given?
  end
  
  def self.get key
    Options[key]
  end
  
  def self.set key, value
    Options[key] = value
  end
  
  def self.instance
    @@instance ||= Engine.new
  end
end