module Basher
  module UI
    class LoadingView < BaseView
      attr_accessor :text

      def setup
        puts text, h: :center, v: :center
      end
    end
  end
end
