module Basher
  module UI
    class InfoView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        clear
        window.attron(Ncurses::A_REVERSE)

        # Draw the bar first
        bar = Array.new(game.level.remaining.size, word_bar).join
        puts bar, h: :center

        # Add Level info above
        puts "| Level #{game.level.difficulty} |", h: :center

        window.attroff(Ncurses::A_REVERSE)
      end

      private

      def word_bar
        '-' * word_width
      end

      def word_width
        size.columns / game.level.words.size
      end
    end
  end
end
