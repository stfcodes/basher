require 'basher/ui/base_view'
require 'basher/ui/debug_view'
require 'basher/ui/loading_view'
require 'basher/ui/title_view'
require 'basher/ui/menu_view'
require 'basher/ui/current_word_view'
require 'basher/ui/remaining_words_view'
require 'basher/ui/score_view'

module Basher
  module UI
    module_function

    def views
      views = case state.current
        when :loading
          [loading_view]
        when :menu
          [title_view, menu_view]
        when :in_game
          [current_word_view, remaining_words_view]
        when :score
          [score_view]
        when :paused
          [title_view, menu_view]
        else
          []
        end
      views << debug_view if debugging?

      views
    end

    def debug_view
      @debug_view ||= DebugView.new do |v|
        v.lines   = DebugView.lines
        v.game    = self
      end

      @debug_view
    end

    def loading_view
      @loading_view ||= LoadingView.new do |v|
        v.text = 'Loading...'
      end
    end

    def title_view
      @title_view ||= TitleView.new do |v|
        v.lines   = TitleView.lines
        v.line    = -> {
          (v.parent.lines - TitleView.lines - MenuView.lines) / 2
        }
        v.state     = state
      end
    end

    def menu_view
      @menu_view ||= MenuView.new do |v|
        v.lines     = MenuView.lines
        v.line      = -> { v.parent.lines - MenuView.lines }
        v.state     = state
      end
    end

    def current_word_view
      @current_word_view ||= CurrentWordView.new do |v|
        v.lines = CurrentWordView.lines
        v.line  = -> {
          (v.parent.lines - CurrentWordView.lines) / 2
        }
        v.game = self
      end
    end

    def remaining_words_view
      @remaining_words_view ||= RemainingWordsView.new do |v|
        v.lines = RemainingWordsView.lines
        v.line  = -> {
          v.parent.lines / 2 + CurrentWordView.lines
        }
        v.game = self
      end
    end

    def score_view
      @score_view ||= ScoreView.new do |v|
        v.lines = ScoreView.lines
        v.line  = -> {
          (v.parent.lines - ScoreView.lines) / 2
        }
        v.game = self
      end
    end

  end
end
