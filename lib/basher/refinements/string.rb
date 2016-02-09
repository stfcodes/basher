require 'artii'

module Basher
  module StringRefinements
    refine String do
      def ascii(font: 'broadway')
        Artii::Base.new(font: font).asciify(self)
      end

      def ascii_size(font: 'broadway')
        ascii(font: font).lines.map(&:size).max
      end
    end
  end
end
