module Basher
  class Handler
    class << self
      attr_reader :bindings

      def bind(*keys, &action)
        @bindings ||= {}
        keys.map(&:to_sym).each do |key|
          @bindings[key] = action
        end
      end
    end

    attr_reader :bindings

    def initialize(custom_bindings = {})
      @bindings = self.class.bindings.merge(custom_bindings)
    end

    def invoke(key)
      bindings.fetch(key.to_sym, -> {}).call
    end
  end
end
