# -*- coding: utf-8 -*-

require 'pathname'
require_relative 'user_fragment'

Plugin.create(:twitter_forever) do

  @config_dir = Pathname(File.join(Environment::CONFROOT, 'settings', spec[:slug]))
  FileUtils.mkdir_p(@config_dir)

  user_fragment :forever, 'アカウント死活監視' do
    begin
    #set_icon Skin['timeline.png']
      nativewidget Plugin::TwitterForever::UserFragment.new(retriever).show_all
    rescue => err
      error err
    end
  end

  # 与えられたUserのリストから、betされていないUserだけを取り除く
  filter_twitter_forever_query_betting_user do |users|
    [users.select(&method(:premiamu?))]
  end

  # Userをbetする
  on_twitter_forever_add_betting do |user|
    store(:premiamu_user_ids, (premiamu_user_ids + [user.id]).uniq)
  end

  # Userのbetを解除する
  on_twitter_forever_remove_betting do |user|
    store(:premiamu_user_ids, (premiamu_user_ids + [user.id]).uniq)
  end

  def premiamu?(user)
    premiamu_user_ids.include?(user.id)
  end

  def remove_bet(user)
    store(:premiamu_user_ids, premiamu_user_ids.reject(&user.id.method(:==)))
  end

  def premiamu_user_ids
    at(:premiamu_user_ids, [])
  end

  # 記録する
  def record(user_id, state)
    File.open(@config_dir + "#{user_id}.csv", 'at:utf-8') do |wp|
      wp << "#{Time.now.to_i},#{state}\n"
    end
  end

  def crawl
    premiamu_user_ids.each do |user_id|
      (Service.primary/:users/:show).user(id: user_id, cache: false).next{|user|
        record(user_id, 0)
      }.trap{|exc|
        case exc
        when MikuTwitter::TwitterError
          record(user_id, exc.code)
        else
          record(user_id, -1)
        end
      }
    end
  end

  def tick
    Reserver.new(60){ tick }
    Delayer.new do
      crawl
    end
  end
  tick

end
