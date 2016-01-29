require 'basher/ui/base_view'
require 'basher/ui/loading_view'
require 'basher/ui/title_view'
require 'basher/ui/menu_view'

module Basher
  module UI
    module_function

    def views
      case state.current
      when :loading
        [loading_view]
      when :menu
        [title_view, menu_view]
      end
    end

    def loading_view
      @loading_view ||= LoadingView.new do |v|
        v.text = 'Loading...'
      end
    end

    def title_view
      @title_view ||= TitleView.new do |v|
        v.lines   = -> { TitleView.lines }
        v.line    = -> {
          (v.parent.lines - TitleView.lines - MenuView.lines) / 2
        }
        v.text    = 'Basher Basher!'
      end
    end

    def menu_view
      @menu_view ||= MenuView.new do |v|
        v.lines     = -> { MenuView.lines }
        v.line      = -> { v.parent.lines - MenuView.lines }
        v.items     = %w([S]tart [Q]uit)
        v.item_sep  = ' | '
      end
    end

  end
end
