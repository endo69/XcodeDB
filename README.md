XcodeDB<br />
=======<br />
<br />
xcodeからpearみたいにdbを操作できればいいなと。<br />
<br />
準備<br /><br />
1.libsqlite3.0.dylibをフレームワークに追加<br />
2.DBClassディレクトリをプロジェクトに入れる<br />
3.sqlite3で作成したDBをプロジェクトに入れる<br />
<br />
使用方法<br />
使用したいファイルで<br />
//インポート<br />
#import "DB.h"<br />
<br />
//インスタンス作成<br />
DB *db = [[DB alloc]init];<br />
//DB接続<br />
[db openDatabase];<br />
//実行するSQL,whereの条件値は?にする<br />
NSString *sql = @"select * from test where id = ? ";<br />
//上記の?と紐づくデータをarrayにpushして行く<br />
NSMutableArray *param = [[NSMutableArray alloc]init];<br />
[param addObject:@"1"];<br />
//データゲット<br />
NSArray *list = [db getAll:sql:param];<br />
