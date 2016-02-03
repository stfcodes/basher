require 'artii'

module Basher
  module StringRefinements
    refine String do
      def ascii(font: 'broadway')
        Artii::Base.new(font: font).asciify(self)
      end
    end
  end
end
