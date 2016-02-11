require 'curtis'
require 'basher/refinements/string'
require 'basher/version'
require 'basher/ui'
require 'basher/game'

module Basher
  module_function

  def start(**options)
    Curtis.show do |screen|
      game = Basher::Game.new(screen, options)

      Curtis::Input.get do |key|
        result = game.handle(key)
        break if result == :quit
        game.render
      end
    end
  end
end
