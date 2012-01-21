require './blag.rb'

use Rack::Reloader


Blag::configure do
end

run Blag::instance