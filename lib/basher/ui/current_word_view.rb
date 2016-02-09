module Basher
  module UI
    class CurrentWordView < BaseView
      using Basher::StringRefinements

      attr_accessor :game

      def self.lines
        10
      end

      def setup
        clear
        text = game.word.remaining.ascii(font: 'roman')

        window.attron(Ncurses::A_BOLD)
        text.lines.each do |line|
          puts line, h: :center
        end
        window.attroff(Ncurses::A_BOLD)
      end
    end
  end
end
