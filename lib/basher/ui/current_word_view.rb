module Basher
  module UI
    class CurrentWordView < BaseView
      attr_accessor :game

      def self.lines
        6
      end

      def setup
        clear
        puts game.current_word, h: :center, v: :center
      end
    end
  end
end
