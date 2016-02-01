module Basher
  class Timer
    attr_reader :started_at, :stopped_at

    def initialize
      @started_at = now
    end

    def elapsed
      ((looking_at - started_at) * 1000).ceil
    end

    def stop
      @stopped_at = now
    end

    def reset
      @started_at = now
      @stopped_at = nil
    end

    private

    def now
      Time.now
    end

    def running?
      @stopped_at.nil?
    end

    def looking_at
      running? ? now : stopped_at
    end

  end
end
