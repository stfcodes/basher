module Basher
  module UI
    class TitleView < BaseView
      attr_accessor :text

      def self.lines
        10
      end

      def setup
        border
        puts text, h: :center, v: :center
      end
    end
  end
end
