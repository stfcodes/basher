module Basher
  module UI
    class InfoView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        window.attron(Ncurses::A_BOLD)
        puts "Level #{game.level.difficulty}:", h: :right
        window.attroff(Ncurses::A_BOLD)
      end
    end
  end
end
