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

      def clear(also_thread = true)
        clear_thread! if also_thread
        window.clear
      end
    end
  end
end
