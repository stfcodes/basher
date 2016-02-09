module Basher
  module UI
    class MenuView < BaseView

      attr_accessor :state

      def self.lines
        1
      end

      def items
        case state.current
        when :menu    then %w([S]-Start [Q]-Quit)
        when :paused  then %w([ESC]-Resume [Q]-Menu)
        else []
        end.join(' | ')
      end

      def setup
        puts items, h: :center
      end
    end
  end
end
