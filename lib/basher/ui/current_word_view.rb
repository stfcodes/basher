module Basher
  module UI
    class CurrentWordView < BaseView
      attr_accessor :game

      def self.lines
        6
      end

      def setup
        clear
        puts game.word.remaining, h: :center, v: :center
      end
    end
  end
end
