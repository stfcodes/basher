require 'basher/ui/base_view'
require 'basher/ui/debug_view'
require 'basher/ui/loading_view'
require 'basher/ui/title_view'
require 'basher/ui/menu_view'
require 'basher/ui/current_word_view'
require 'basher/ui/info_view'
require 'basher/ui/remaining_words_view'
require 'basher/ui/score_view'

module Basher
  module UI
    def views
      @views ||= methods.grep(/(?<!base)_view/).map { |v| self.public_send(v) }.flatten
    end

    def current_views
      views = case state.current
        when :loading
          [loading_view]
        when :menu
          [title_view, menu_view]
        when :in_game
          [current_word_view, info_view, remaining_words_view]
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
        v.game    = self

        v.lines   = DebugView.lines
      end
    end

    def loading_view
      @loading_view ||= LoadingView.new do |v|
        v.text = 'Loading...'
      end
    end

    def title_view
      @title_view ||= TitleView.new do |v|
        v.state     = state

        v.lines   = TitleView.lines
        v.line    = -> {
          (v.parent.lines - TitleView.lines - MenuView.lines) / 2
        }
      end
    end

    def menu_view
      @menu_view ||= MenuView.new do |v|
        v.state     = state

        v.lines     = MenuView.lines
        v.line      = -> { v.parent.lines - MenuView.lines }
      end
    end

    def current_word_view
      @current_word_view ||= CurrentWordView.new do |v|
        v.game = self

        v.lines = CurrentWordView.lines
        v.line  = -> {
          (v.parent.lines - CurrentWordView.lines) / 2
        }
      end
    end

    def remaining_words_view
      @remaining_words_view ||= RemainingWordsView.new do |v|
        v.game = self

        v.lines   = RemainingWordsView.lines
        v.columns = -> { v.parent.columns * 8 / 10.to_f }
        v.line    = -> {
          v.parent.lines / 2 + CurrentWordView.lines
        }
        v.column = -> { v.parent.columns * 3 / 10.to_f }
      end
    end

    def info_view
      @info_view ||= InfoView.new do |v|
        v.game    = self

        v.lines   = InfoView.lines
        v.columns = -> { v.parent.columns * 2 / 10.to_f }
        v.line    = -> {
          v.parent.lines / 2 + CurrentWordView.lines
        }
      end
    end

    def score_view
      @score_view ||= ScoreView.new do |v|
        v.game = self

        v.lines = ScoreView.lines
        v.line  = -> {
          (v.parent.lines - ScoreView.lines) / 2
        }
      end
    end
  end
end
