require 'rack'
require './blag.rb'

use Rack::Reloader


app = Blag::Blag.new do
end

run app