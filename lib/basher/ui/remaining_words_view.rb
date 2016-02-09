module Basher
  module UI
    class RemainingWordsView < BaseView
      attr_accessor :game

      def self.lines
        1
      end

      def setup
        clear

        if will_overflow?
          trimmed = remaining_words.join(' ')[0..(parent.columns - 1)]
          words   = trimmed[0..(trimmed.rindex(' ') - 1)]
        else
          words   = remaining_words.join(' ')
        end

        puts words, h: :left
      end

      private

      def remaining_words
        game.level.remaining[1..-1]
      end

      def will_overflow?
        remaining_words.join(' ').size > columns
      end
    end
  end
end
