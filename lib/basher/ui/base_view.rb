module Basher
  module UI
    class BaseView < Curtis::View

      attr_accessor :should_redraw

      def initialize
        self.should_redraw = false
        super
      end

      def will_resize!
        self.should_redraw = true
      end

      def resize_and_reposition
        reposition
        resize
        self.should_redraw = false
      end
    end
  end
end
