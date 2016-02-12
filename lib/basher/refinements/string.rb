require 'artii'

module Basher
  module StringRefinements
    refine String do
      def ascii(font: 'broadway')
        Artii::Base.new(font: font).asciify(self)
      end

      def ascii_lines(font: 'broadway')
        ascii(font: font).lines.map do |line|
          line.gsub("\n", '')
        end
      end

      def ascii_size(font: 'broadway')
        ascii_lines(font: font).map(&:size).max
      end
    end
  end
end
