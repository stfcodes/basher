module Basher
  module UI
    class ProgressView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        clear
        render every: 0.1 do
          clear(false)
          window.attron(Ncurses::A_BOLD)
          puts '=' * remaining, h: :left
          window.attroff(Ncurses::A_BOLD)
        end
      end

      private

      def remaining
        value   = game.level.time_limit - game.level.timer.total_elapsed
        result  = value.to_f / game.level.time_limit
        (size.columns * result).floor - 1
      end
    end
  end
end
