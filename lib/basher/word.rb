require 'forwardable'

module Basher
  # Initializing a word with a string, returns a Basher::Word instance
  # that holds a frozen reference to the original string, and has a cursor
  # used for moving between the items in the string in a OOP fashion.
  class Word
    # Delegate cursor methods to the word itself.
    extend Forwardable
    def_delegators :cursor, :position, :previous,
      :remaining, :advance!, :rewind!, :finished?
    def_delegator :cursor, :item, :char

    # Frozen reference of the word.
    attr_reader :string
    # Basher::Word::Cursor instance.
    attr_reader :cursor

    # Returns a Word instance for the given string. The cursor's public
    # methods are delegated to this instance as well.
    def initialize(string)
      @string = string.dup.freeze
      @cursor = Cursor.new(@string)
    end

    # :nodoc:
    def inspect
      string
    end

    # :nodoc:
    def to_s
      string
    end
  end
end
