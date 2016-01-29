module Basher
  module UI
    class MenuView < BaseView
      attr_accessor :items, :item_sep

      def self.lines
        3
      end

      def setup
        move_cursor line: 1, column: 0
        puts items.join(item_sep), h: :center
      end
    end
  end
end
