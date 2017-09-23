# なんこれ

あの人のアカウントが凍結されたらすぐに知りたい！っていうTwitterアカウント、ありませんか？

このプラグインは、そういうアカウントを定期的にクロールして、返ってきたエラー番号を記録するプラグインです。

# インストール方法

    $ git clone https://github.com/toshia/twitter_forever.git ~/.mikutter/plugin/twitter_forever/

# 使い方

ユーザのプロフィールを開くと、以下のような明らかに突貫工事なタブが出てきます。
これを選択すると、説明だるいからあとはスクショ見てくれ

![](https://github.com/toshia/twitter_forever/blob/screenshot/screenshot.png?raw=true)

1分ごとに、チェックがついたアカウントにAPIリクエストを行い、エラー番号を `~/.mikutter/settings/twitter_forever/(ユーザID).csv` に保存します。
CSVファイルには、クロールする度に

    タイムスタンプ(unixtime),エラー番号

という行を末尾に追記していきます。
