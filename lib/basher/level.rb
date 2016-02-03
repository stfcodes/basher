require 'forwardable'

module Basher
  # Handles the initialization of a single level in the game.
  # The defining characteristic of a level is it's #difficulty, which
  # controls the number of the words in the level, and their size.
  #
  # TODO: Extract constants to global configuration values.
  class Level
    # Delegate cursor methods to the word itself.
    extend Forwardable
    def_delegators :cursor, :position, :previous,
      :remaining, :advance!, :rewind!, :finished?

    def_delegator :cursor, :item, :word

    # How many words per difficulty level
    WORDS_PER_DIFFICULTY = 3

    # Maximum difficulty
    MAX_DIFFICULTY = 12

    # Use this attribute to determine the number of the words,
    # and the length of the words.
    attr_reader :difficulty
    attr_reader :words
    attr_reader :cursor

    # Returns a Level instance with the default difficulty of 1.
    def initialize(difficulty = 1)
      @difficulty = difficulty || 1
      check_difficulty!
      @words      = initialize_words
      @cursor     = Cursor.new(words)
    end

    private

    # Get an array of words that are calculated based on the difficulty.
    # The bigger the difficulty, the bigger the words.
    def initialize_words
      word_sizes.map do |size|
        Array.new(WORDS_PER_DIFFICULTY).map do
          Basher::Word.new Basher::Dictionary.random_word(size)
        end
      end.flatten
    end

    def word_sizes
      size = difficulty + 2

      case difficulty
      when 1
        [size, size + 1, size + 1]
      when MAX_DIFFICULTY
        [size - 1, size, size]
      else
        [size - 1, size, size + 1]
      end
    end

    private

    def check_difficulty!
      if difficulty > MAX_DIFFICULTY
        fail "Difficulty can't be higher than max difficulty"
      end
    end

  end
end
