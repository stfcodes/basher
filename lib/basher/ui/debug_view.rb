module Basher
  module UI
    class DebugView < BaseView
      attr_accessor :game
      attr_accessor :last_input

      def self.lines
        1
      end

      def setup
        draw_text = -> {
          setup_left_part
          setup_right_part
        }

        if game.state.in_game?
          clear
          render every: 0.04 do
            draw_text.call
          end
        else
          clear
          draw_text.call
        end
      end

      private

      def setup_left_part
        state     = game.state.current
        left_part = [state, last_input].compact

        if game.state.in_game?
          seconds_elapsed = game.timer.total_elapsed
          left_part.unshift seconds_elapsed
        end

        puts left_part.join(' | '), h: :left
      end

      def setup_right_part
        active_views  = game.send(:current_views).map do |v|
          v.class.to_s.gsub(/^.*::/, '')
        end.join(', ')
        terminal_size = game.base_view.size

        right_part = [active_views, terminal_size].join(' | ')
        puts right_part, h: :right
      end
    end
  end
end
