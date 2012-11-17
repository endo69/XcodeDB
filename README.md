XcodeDB<br />
=======<br />
<br />
xcodeからpearみたいにdbを操作できればいいなと。<br />
<br />
準備<br /><br />
1.libsqlite3.0.dylibをフレームワークに追加<br />
2.DBClassディレクトリをプロジェクトに入れる<br />
3.sqlite3で作成したDBをプロジェクトに入れる<br />
4.DB.mの中のデータベース名を自分の物に合わせて変更する<br />
<br />
使用方法<br />
使用したいファイルで<br />
インポート<br />
import "DB.h"<br />
<br />
//インスタンス作成<br />
DB *db = [[DB alloc]init];<br />
//DB接続<br />
[db openDatabase];<br />
<br />
<br />
//リストで取得したい時<br />
//実行するSQL,whereの条件値は?にする<br />
NSString *sql = @"select * from test where id = ? ";<br />
//上記の?と紐づくデータをarrayにpushして行く<br />
NSMutableArray *param = [[NSMutableArray alloc]init];<br />
[param addObject:@"1"];<br />
//データゲット<br />
NSArray *list = [db getAll:sql:param];<br />
<br />
<br />
//一行取得したい時<br />
//SQL 条件値は?にする<br />
NSString *sql = @"select * from test where id = ?";<br />
//?を変換する配列<br />
NSMutableArray *param = [[NSMutableArray alloc]init];<br />
//idは1の条件で<br />
[param addObject:@"1"];<br />
//ゲット<br />
NSDictionary *data = [db getRow:sql:param];<br />
<br />
<br />
//インサートする時<br />
//テーブル名指定<br />
NSString *table = @"test";<br />
//ディクショナリ形式でデータ渡す<br />
NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];<br />
//idカラムに4を入れる場合<br />
[dict setObject:@"4" forKey:@"id"];<br />
//nameからむにsatomiを入れる場合<br />
[dict setObject:@"satomi" forKey:@"name"];<br />
<br />
//実行<br />
[db insert:table:dict];<br />
<br />
<br />
//アップデートする時<br />
//テーブル指定<br />
NSString *table = @"test";<br />
//ディクショナリ作成<br />
NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];<br />
//nameをsatoshiに変更する<br />
[dict setObject:@"satoshi" forKey:@"name"];<br />
//条件用のディクショナリを作成<br />
NSMutableDictionary *where = [[NSMutableDictionary alloc]init];<br />
//条件はidが3ということで。<br />
[where setObject:@"3" forKey:@"id"];<br />
//アップデート<br />
[db update:table:dict:where];<br />
<br />
<br />
//デリートする時<br />
//テーブル指定<br />
NSString *table = @"test";<br />
//条件用のディクショナリを作成<br />
NSMutableDictionary *where = [[NSMutableDictionary alloc]init];<br />
//条件はidが3ということで。<br />
[where setObject:@"1" forKey:@"id"];<br />
//アップデート<br />
[db delete:table:where];<br />
