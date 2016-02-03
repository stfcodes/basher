require 'artii'
require 'pry'
require 'binding_of_caller'

module Basher
  module StringRefinements
    refine String do
      def ascii(font: 'broadway')
        asciifier = Artii::Base.new(font: font)
        art       = asciifier.asciify(self)
        lines     = art.lines.map { |l| l.gsub("\n", '') }
        lines.select { |l| !l.strip.empty? }.join("\n")
      end
    end
  end
end
