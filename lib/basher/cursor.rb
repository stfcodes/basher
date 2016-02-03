module Basher
  # Helper class that allows storing movement state inside a collection.
  class Cursor
    # Frozen reference of the word.
    attr_reader :collection
    # Position of the cursor inside #collection. Default is 0.
    attr_reader :index

    # Returns a Cursor instance for the given collection. The cursor's
    # index is defaulted to 0.
    def initialize(collection)
      @collection = collection
      @index      = 0
    end

    # Gets the item at the cursor.
    def item
      collection[index]
    end

    # Gets the items before the cursor.
    def previous
      collection[0...index]
    end

    # Gets remaining items, including item at the cursor.
    def remaining
      collection[index..-1]
    end

    # Advance the cursor one step.
    def advance!
      @index += 1 unless finished?
      item
    end

    # Rewind the cursor back to start, and return the item.
    def rewind!
      @index = start
      item
    end

    # Returns true if the cursor is at the last index,
    # or false otherwise.
    def finished?
      index == finish
    end

    private

    def start
      0
    end

    def finish
      collection.size
    end
  end
end
