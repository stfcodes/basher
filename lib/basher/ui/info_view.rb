module Basher
  module UI
    class InfoView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        clear
        render every: 0.04 do
          window.attron(Ncurses::A_BOLD)

          puts "Level #{game.level.difficulty} #{remaining}: ", h: :right
          window.attroff(Ncurses::A_BOLD)
        end
      end

      private

      def remaining
        value = game.level.time_limit - game.level.timer.elapsed
        Time.at(value / 1000.to_f).strftime("%S.%L").ljust(6)
      end
    end
  end
end
