module Basher
  module UI
    class RemainingWordsView < BaseView
      attr_accessor :game

      def self.lines
        3
      end

      def setup
        clear
        words = game.level.remaining[1..-1].join(' ')
        puts words, h: :center, v: :center
      end
    end
  end
end
