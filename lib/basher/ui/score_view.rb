module Basher
  module UI
    class ScoreView < BaseView
      attr_accessor :game

      def self.lines
        6
      end

      def setup
        elapsed = game.timer.total_elapsed_humanized
        accuracy = "%s %" % (game.accuracy * 100).to_i
        misses   = game.misses

        move_cursor line: 2
        puts "Total Elapsed: #{elapsed}", h: :center
        move_cursor line: 3
        puts "Accuracy: #{accuracy} (#{misses} misses)", h: :center
      end
    end
  end
end
