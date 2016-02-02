module Basher
  class Handler
    ALPHABET = ('a'..'z').to_a.freeze

    class << self
      attr_reader :bindings

      def bind(*keys, &action)
        @bindings ||= {}
        keys.map(&:to_sym).each do |input|
          @bindings[input] ||= []
          @bindings[input] << action
        end
      end
    end

    attr_reader :bindings

    def initialize(custom_bindings = {})
      @bindings = self.class.bindings.merge(custom_bindings)
    end

    def invoke(input)
      bindings.fetch(input.to_sym, []).map do |b|
        b.call(input)
      end.last
    end

    def letter?(input)
      return false if input.size != 1
      input =~ /[[:alpha:]]/
    end
  end
end
