XcodeDB
=======

xcodeからpearみたいにdbを操作できればいいなと。

準備<br />
1.libsqlite3.0.dylibをフレームワークに追加
2.DBClassディレクトリをプロジェクトに入れる
3.sqlite3で作成したDBをプロジェクトに入れる

使用方法
使用したいファイルで
//インポート
#import "DB.h"

//インスタンス作成
DB *db = [[DB alloc]init];
//DB接続
[db openDatabase];
//実行するSQL,whereの条件値は?にする
NSString *sql = @"select * from test where id = ? ";
//上記の?と紐づくデータをarrayにpushして行く
NSMutableArray *param = [[NSMutableArray alloc]init];
[param addObject:@"1"];
//データゲット
NSArray *list = [db getAll:sql:param];
