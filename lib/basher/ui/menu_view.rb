module Basher
  module UI
    class MenuView < BaseView

      attr_accessor :state

      def self.lines
        3
      end

      def items
        case state.current
        when :menu    then %w([S]-Start [Q]-Quit)
        when :paused  then %w([ESC]-Resume [Q]-Menu)
        else []
        end
      end

      def setup
        move_cursor line: 1, column: 0
        puts items.join(' | '), h: :center
      end
    end
  end
end
