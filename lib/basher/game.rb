require 'basher/timer'
require 'basher/state'
require 'basher/handler'
require 'basher/dictionary'
require 'basher/cursor'
require 'basher/word'
require 'basher/level'


module Basher
  class Game
    include UI

    attr_reader :base_view
    attr_reader :timer
    attr_reader :handler
    attr_reader :state
    attr_reader :debug

    attr_reader :difficulty
    attr_reader :level
    attr_reader :misses
    attr_reader :characters
    attr_reader :words

    private def setup_default_bindings
      Handler.bind :resize do
        resize_and_reposition
      end

      Handler.bind 'q' do
        case state.current
        when :paused  then back_to_menu
        when :menu    then :quit
        when :score   then back_to_menu
        end
      end

      Handler.bind :escape do
        case state.current
        when :in_game
          timer.stop
          transition_to(:paused)
        when :paused
          timer.start
          transition_to(:in_game)
        when :score
          back_to_menu
        end
      end

      Handler.bind :enter do
        case state.current
        when :score
          back_to_menu
        end
      end

      Handler.bind 's' do
        case state.current
        when :menu
          start_game
        end
      end
    end

    def initialize(base_view:, state: :menu, debug: false, bindings: {})
      @debug = debug

      @base_view = base_view
      base_view.refresh

      @state = State.new(state)

      setup_default_bindings
      @handler = Handler.new(bindings)

      transition_to @state.current
      @timer = Timer.new
    end

    def handle(input)
      debug_view.last_input = input if debugging?

      if state.in_game? && handler.letter?(input)
        execute_logic input
      end

      handler.invoke(input)
    end

    def execute_logic(char)
      return @misses += 1 unless char == word.char
      next_letter!
    end

    def word
      level.word
    end

    def next_letter!
      @characters += 1
      word.advance!

      next_word! if word.finished?
    end

    def next_word!
      @words += 1
      level.advance!

      next_level! if level.finished?
    end

    def next_level!
      return stop_game if difficulty >= Level::MAX_DIFFICULTY

      @difficulty += 1
      @level       = Level.new(difficulty)
    end

    def accuracy
      characters.to_f / total_presses
    end

    def words_per_minute
      words * 60 / timer.total_elapsed_in_seconds
    end
    alias_method :wpm, :words_per_minute

    def chars_per_minute
      total_presses * 60 / timer.total_elapsed_in_seconds
    end
    alias_method :cpm, :chars_per_minute

    def total_presses
      characters + misses
    end

    def render
      base_view.render
      views.each(&:render)
    end

    def clear
      base_view.clear
      views.each(&:clear)
    end

    def refresh
      base_view.refresh
      views.each(&:refresh)
    end

    def resize_and_reposition
      clear
      views.each(&:reposition)
      views.each(&:resize)
      render
    end

    def transition_to(new_state)
      before_transition
      state.transition_to(new_state)
      after_transition
    end

    private

    def debugging?
      @debug
    end

    def playing?
      state.playing? && input.letter?
    end

    def before_transition
      clear
      refresh
    end

    def after_transition
      render
    end

    def back_to_menu
      timer.reset
      transition_to(:menu)
    end

    def start_game
      transition_to(:loading)
      Basher::Dictionary.preload
      setup_game
      transition_to(:in_game)
      timer.start
    end

    def stop_game
      timer.stop
      transition_to(:score)
    end

    def setup_game
      @difficulty = 1
      @level      = Level.new(difficulty)

      @characters = 0
      @misses     = 0
      @words      = 0
    end
  end
end
