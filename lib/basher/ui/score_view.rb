module Basher
  module UI
    class ScoreView < BaseView
      attr_accessor :game

      def self.lines
        4
      end

      def setup
        clear

        misses  = game.misses
        wpm     = game.wpm
        cpm     = game.cpm

        puts "Level: #{game.level.difficulty}", h: :center

        cursor.newline!
        puts "(#{total_elapsed})", h: :center

        cursor.newline!
        puts "Words per minute: #{game.words_per_minute}", h: :center

        cursor.newline!
        puts "Chars per minute: #{game.chars_per_minute}", h: :center

        cursor.newline!
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
