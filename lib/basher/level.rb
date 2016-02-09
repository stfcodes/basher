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

    # Biggest word size
    MAX_WORD_SIZE = 15.freeze

    # Word sizes
    WORD_SIZES = (3..MAX_WORD_SIZE).freeze

    # How many words per level
    WORDS_PER_LEVEL = 8.freeze

    # Use this attribute to determine the number of the words,
    # and the length of the words.
    attr_reader :difficulty
    attr_reader :words
    attr_reader :cursor

    # Returns a Level instance with the default difficulty of 1.
    def initialize(difficulty = 1)
      @difficulty = difficulty || 1
      pick_words!
      @cursor = Cursor.new(words)
    end

    def sizes
      WORD_SIZES
    end

    def weights
      sizes.map { |size| calculate(size) }
    end

    def chances
      weights.map { |weight| (weight / total_weight * 100.0).round(2) }
    end

    # Get an array of words that are calculated based on the difficulty.
    # The bigger the difficulty, the bigger the words.
    def pick_words!(words_per_level = WORDS_PER_LEVEL)
      @words = pick(words_per_level).map do |size|
        Basher::Word.new(Basher::Dictionary.random_word(size))
      end
    end

    def pick(words = 15)
      1.upto(words).collect { roll }
    end

    private

    def total_weight
      weights.reduce(:+)
    end

    def roll
      sizes_and_weights = sizes.zip(weights)

      loop do
        sizes_and_weights.shuffle.each do |tuple|
          size, weight = *tuple

          chance = (weight / weights.reduce(:+) * 100.0).round(2)
          rolled = (rand * 100).round(2)
          return size if rolled <= chance
        end
      end
    end

    def calculate(size)
      weight = (difficulty / (size / 2) ) ** size
      weight.round(2)
    end
  end
end
