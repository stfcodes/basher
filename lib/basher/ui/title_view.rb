module Basher
  module UI
    class TitleView < BaseView
      using Basher::StringRefinements

      attr_accessor :state

      def self.lines
        11
      end

      def text
        case state.current
        when :menu   then 'Basher!'
        when :paused then 'Paused'
        else ''
        end
      end

      def setup
        clear
        if will_overflow?
          puts text, h: :center, v: :center
        else
          text.ascii_lines(font: 'broadway').each do |line|
            puts line, h: :center
            cursor.newline!
          end
        end
      end

      private

      def will_overflow?
        text.ascii_size(font: 'broadway') >= parent.columns
      end
    end
  end
end
