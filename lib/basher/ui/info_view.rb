module Basher
  module UI
    class InfoView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        puts "Level #{game.level.difficulty}", h: :center
      end
    end
  end
end
