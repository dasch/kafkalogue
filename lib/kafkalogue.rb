require "kafkalogue/version"

module Kafkalogue
  def self.new(*args)
    Log.new(*args)
  end
end

require 'kafkalogue/log'
