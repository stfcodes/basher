module Basher
  class Timer
    attr_reader :started_at, :stopped_at

    def initialize
      reset
    end

    # Milliseconds
    def elapsed
      return @total_elapsed unless running?
      ((looking_at - started_at) * 1000).ceil
    end

    def total_elapsed
      return @total_elapsed unless running?
      @total_elapsed + elapsed
    end

    def total_elapsed_in_seconds
      (total_elapsed.to_f / 1000).round
    end

    def total_elapsed_humanized
      seconds = total_elapsed_in_seconds
      [[60, :seconds], [60, :minutes], [24, :hours]].map do |count, name|
        if seconds > 0
          seconds, n = seconds.divmod(count)
          "#{n.to_i} #{name}"
        end
      end.compact.reverse.join(' ')
    end

    def start
      @stopped_at = nil
      @started_at = now
    end

    def stop
      @total_elapsed += elapsed
      @stopped_at = now
    end

    def reset
      @stopped_at = nil
      @started_at = nil
      @total_elapsed = 0
    end

    def advance(milliseconds)
      @total_elapsed += milliseconds
    end

    private

    def now
      Time.now
    end

    def running?
      !started_at.nil? && stopped_at.nil?
    end

    def looking_at
      running? ? now : stopped_at
    end

  end
end
