module Basher
  module UI
    class TitleView < BaseView
      using Basher::StringRefinements

      attr_accessor :state

      def self.lines
        10
      end

      def text
        case state.current
        when :menu   then 'Basher!'
        when :paused then 'Paused'
        else ''
        end
      end

      def setup
        text.ascii(font: 'broadway').lines.each do |line|
          puts line, h: :center
        end
      end
    end
  end
end
