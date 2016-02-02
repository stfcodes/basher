module Basher
  module UI
    class ScoreView < BaseView
      attr_accessor :game

      def self.lines
        4
      end

      def setup
        misses  = game.misses
        wpm     = game.wpm
        cpm     = game.cpm

        move_cursor line: 0
        puts "Total Elapsed: #{total_elapsed}", h: :center

        move_cursor line: 1
        puts "Words per minute: #{game.words_per_minute}", h: :center

        move_cursor line: 2
        puts "Chars per minute: #{game.chars_per_minute}", h: :center

        move_cursor line: 3
        puts "Accuracy: #{accuracy} (#{misses} misses)", h: :center
      end

      def total_elapsed
        game.timer.total_elapsed_humanized
      end

      def accuracy
        formula = (game.accuracy * 100).to_i
        "%s %" % formula
      end
    end
  end
end
