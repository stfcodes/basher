module Basher
  module UI
    class CurrentWordView < BaseView
      using Basher::StringRefinements

      attr_accessor :game

      def self.lines
        10
      end

      # TODO: Figure out how to make the text center line not move
      # as fewer letters remain in the word.
      def setup
        clear
        text = game.word.remaining.ascii(font: 'roman')
        text.lines.each do |line|
          puts line, h: :center
        end
      end
    end
  end
end
