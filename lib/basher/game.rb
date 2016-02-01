require 'basher/timer'
require 'basher/state'
require 'basher/handler'

module Basher
  class Game
    include UI

    attr_accessor :base_view
    attr_reader   :timer
    attr_reader   :handler
    attr_reader   :state
    attr_reader   :debug

    attr_reader :current_word
    attr_reader :remaining_words

    attr_reader :misses

    private def setup_default_bindings
      Handler.bind :resize do
        resize_and_reposition
      end

      Handler.bind 'q' do
        case state.current
        when :paused  then transition_to(:menu)
        when :menu    then :quit
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
          timer.reset
          transition_to(:menu)
        end
      end

      Handler.bind 's' do
        case state.current
        when :menu
          transition_to(:loading)
          # Preload data here <<<<<<<
          setup_levels
          transition_to(:in_game)
        end
      end
    end

    def initialize(base_view:, state: :loading, debug: true, bindings: {})
      @debug = debug

      @base_view = base_view
      base_view.refresh

      @state = State.new(state)

      setup_default_bindings
      @handler = Handler.new(bindings)

      transition_to @state.current
      @timer = Timer.new
    end

    def debugging?
      @debug
    end

    def handle(input)
      debug_view.last_input = input if debugging?

      execute!(input) if state.in_game?

      handler.invoke(input)
    end

    def setup_levels
      # @remaining_words = %w(without you magnetic iam believe now random keepin dont drawn get feelin alright somehow).shuffle
      @remaining_words = %w(without you magnetic).shuffle
      @min_hits = @remaining_words.map(&:size).reduce(:+)
      @misses   = 0
      @current_word = @remaining_words.shift
    end

    def execute!(char)
      return @misses += 1 unless @current_word.start_with? char

      @current_word = @current_word[1..-1]

      if @current_word.empty?
        @current_word = @remaining_words.shift
      end

      if @current_word.nil?
        timer.stop
        transition_to(:score)
      else
        @current_word
      end
    end

    def accuracy
      @min_hits.to_f / (@min_hits + @misses)
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

    def before_transition
      clear
      refresh
    end

    def after_transition
      render
    end
  end
end
