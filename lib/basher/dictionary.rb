module Basher
  # Gives samples of random words as single instances or in batches.
  # TODO: Extract constants to global configuration values.
  # TODO: Allow words_list to be a global config option / value.
  module Dictionary
    module_function

    # Where is the words list path on the system. It is also assumed
    # that there is only one word per line.
    WORDS_LIST_PATH = '/usr/share/dict/words'.freeze

    # Filter out words with fewer characters.
    MIN_SIZE = 3
    # Filter out words with more characters.
    MAX_SIZE = 15

    # Small utility function that preloads the words_list.
    def preload
      !words_list.empty?
    end

    # Returns a random word from the words file.
    # The size argument must be greater than MIN_SIZE.
    #
    # +size+ - the size of the returned word.
    def random_word(size = MIN_SIZE)
      # Return any word from the list if we supply size: nil
      return words_list.sample unless size

      grouped_words_list.fetch(size) do
        fail "Size must be in #{MIN_SIZE}..#{MAX_SIZE}"
      end.sample
    end

    # Group words in the list by size.
    def grouped_words_list
      @grouped_words_list ||= words_list.group_by(&:size)
    end

    # Returns an array of words, read from a file. Also caches the list.
    def words_list
      @words_list ||= File.open(WORDS_LIST_PATH, 'r') do |file|
        file.each_line.lazy
          .map    { |word| word.chomp.downcase }
          .select { |word| word =~ /\A[a-z]{#{MIN_SIZE},#{MAX_SIZE}}\z/ }
          .to_a
      end
    end
  end
end
