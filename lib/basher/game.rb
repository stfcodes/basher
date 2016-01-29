module Basher
  class Game
    include UI

    attr_accessor :window
    attr_reader   :handler
    attr_reader   :state

    def initialize(state: :loading, window: Curtis.screen, bindings: {})
      @window = window
      window.refresh

      @state = State.new(state)

      setup_default_bindings
      @handler = Handler.new(bindings)

      transition_to @state.current
    end

    def handle(key)
      handler.invoke(key)
    end

    def render
      views.each(&:render)
    end

    def clear_views
      views.each(&:clear)
    end

    def resize
      window.clear
      window.render
      clear_views
      views.each(&:resize)
      render
    end

    def transition_to(new_state)
      clear_views
      state.transition_to(new_state)
      render
    end

    private

    def setup_default_bindings
      Handler.bind :resize do
        resize
      end

      Handler.bind :q, :escape do
        :quit unless state.loading? || state.in_game?
      end
    end

  end
end
