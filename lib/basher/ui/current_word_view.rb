module Basher
  module UI
    class CurrentWordView < BaseView
      attr_accessor :game

      def self.lines
        9
      end

      # TODO: Figure out how to make the text center line not move
      # as fewer letters remain in the word.
      def setup
        clear
        text = game.word.remaining.ascii(font: 'roman')
        # Height ranges from 5 to 9
        height = text.lines.size
        offset = (9 - height) / 2
        move_cursor line: offset

        text.lines.each_with_index do |line, index|
          puts line, h: :center
        end
      end
    end
  end
end
