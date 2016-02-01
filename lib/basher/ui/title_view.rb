module Basher
  module UI
    class TitleView < BaseView
      attr_accessor :state

      def self.lines
        10
      end

      def text
        case state.current
        when :menu   then 'Basher Basher!'
        when :paused then 'Paused'
        else ''
        end
      end

      def setup
        border
        puts text, h: :center, v: :center
      end
    end
  end
end
