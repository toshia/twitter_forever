# -*- coding: utf-8 -*-

module Plugin::TwitterForever
  class UserFragment < Gtk::VBox
    def initialize(user, *rest)
      super(*rest)
      @user = user

      account_check = Gtk::CheckButton.new('アカウントの消息を監視する').
                        set_active(betting?)
      closeup(account_check)
      account_check.ssc(:toggled, &gen_betting_toggled)
    end

    def betting?
      betting_users,  = Plugin.filtering(:twitter_forever_query_betting_user, [@user])
      betting_users.include?(@user)
    end

    def gen_betting_toggled
      ->(widget) do
        Plugin.call(widget.active? ? :twitter_forever_add_betting : :twitter_forever_remove_betting, @user)
        false
      end
    end
  end
end
