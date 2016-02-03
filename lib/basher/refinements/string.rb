require 'artii'

module Basher
  module StringRefinements
    refine String do
      def ascii(font: 'broadway')
        asciifier = Artii::Base.new(font: font)
        art = asciifier.asciify(self)

        # First remove the newlines
        lines = art.lines.map { |l| l.gsub("\n", '') }

        # Some Artii fonts have empty lines before the
        #  actual character lines, so remove them.
        first_non_empty_line = lines.index { |l| !l.strip.empty? }
        lines = lines[first_non_empty_line..-1]

        # Now remove the last empty lines, and return a string
        first_empty_line = lines.index { |l| l.strip.empty? }
        lines[0..(first_empty_line || -1)].join("\n")
      end
    end
  end
end
