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

        remaining = game.word.remaining
        window.attron(Ncurses::A_BOLD)

        if will_overflow?
          puts remaining, h: :center, v: :center
        else
          text = remaining.ascii(font: 'roman')

          text.lines.each do |line|
            puts line, h: :center
          end
        end

        window.attroff(Ncurses::A_BOLD)
      end

      private

      def will_overflow?
        game.word.string.ascii_size(font: 'roman') >= parent.size.columns
      end
    end
  end
end
