module Basher
  class State
    TRANSITIONS = {
      loading:  %i(menu in_game),
      menu:     %i(loading),
      in_game:  %i(paused score),
      paused:   %i(in_game menu),
      score:    %i(menu)
    }.freeze

    class << self
      def all
        TRANSITIONS.keys
      end
    end

    attr_reader :current

    def initialize(initial_state = :loading)
      @current = initial_state
    end

    TRANSITIONS.keys.each do |state|
      define_method "#{state}?" do
        current == state
      end

      define_method "#{state}!" do
        @current = state
      end
    end

    def transitions
      TRANSITIONS.fetch(current, [])
    end

    def transition_to(state)
      @current = state if transitions.include?(state)
    end
  end
end
