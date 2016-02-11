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
          pause_game
        when :paused
          back_to_game
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

    def initialize(base_view, state: :menu, debug: false, bindings: {})
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
      if char == word.char
        next_letter!
      else
        @misses += 1
        level.timer.advance(200)
      end
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
      @difficulty += 1
      level.finish if level

      @level = Level.start(difficulty) do
        stop_game
      end
    end

    def accuracy
      return 0 if total_presses.zero?
      value = (total_presses - misses).to_f / total_presses * 100
      value.round(2)
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
      current_views.each(&:render)
    end

    def clear
      base_view.clear
      current_views.each(&:clear)
    end

    def refresh
      base_view.refresh
      current_views.each(&:refresh)
    end

    def resize_and_reposition
      clear
      views.each(&:will_resize!)
      current_views.each(&:resize_and_reposition)
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
      views.each do |view|
        view.resize_and_reposition if view.should_redraw
      end

      render
    end

    def pause_game
      timer.stop
      level.timer.stop
      transition_to(:paused)
    end

    def back_to_menu
      timer.reset
      transition_to(:menu)
    end

    def back_to_game
      timer.start
      level.timer.start
      transition_to(:in_game)
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
      @difficulty = 0
      @characters = 0
      @misses     = 0
      @words      = 0
      next_level!
    end
  end
end
