module Basher
  class Timer
    attr_reader :started_at, :stopped_at, :total_elapsed

    def initialize
      @started_at = now
      @total_elapsed = 0
    end

    def elapsed
      ((looking_at - started_at) * 1000).ceil
    end

    def total_elapsed
      running? ? @total_elapsed + elapsed : @total_elapsed
    end

    def total_elapsed_humanized
      seconds = total_elapsed / 1000
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
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
