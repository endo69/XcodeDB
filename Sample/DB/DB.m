//
//  DB.m
//  DB
//
//  Created by 遠藤 秀春 on 12/11/17.
//  Copyright (c) 2012年 HaruzoWorks. All rights reserved.
//

#import "DB.h"
#import "FMDatabase.h"

//DBファイル名
static NSString* const DB_FILE = @"database.sqlite";

@implementation DB {
    FMDatabase*     _db;
}

- (BOOL)openDatabase {
    //DBファイルへのパスを取得
    //パスは~/Documents/配下に格納される。
    NSString *dbPath = nil;
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    //取得データ数を確認
    if ([documentsPath count] >= 1) {
        //固定で0番目を取得でOK
        dbPath = [documentsPath objectAtIndex:0];
        //パスの最後にファイル名をアペンドし、DBファイルへのフルパスを生成。
        dbPath = [dbPath stringByAppendingPathComponent:DB_FILE];
        NSLog(@"db path : %@", dbPath);
    } else {
        //error
        NSLog(@"search Document path error. database file open error.");
        return false;
    }
    
    //DBファイルがDocument配下に存在するか判定
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        //存在しない
        //デフォルトのDBファイルをコピー(初回のみ)
        //ファイルはアプリケーションディレクトリ配下に格納されている。
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *orgPath = [bundle bundlePath];
        //初期ファイルのパス。(~/XXX.app/sample.db)
        orgPath = [orgPath stringByAppendingPathComponent:DB_FILE];
        
        //デフォルトのDBファイルをDocument配下へコピー
        if (![fileManager copyItemAtPath:orgPath toPath:dbPath error:nil]) {
            //error
            NSLog(@"db file copy error. : %@ to %@.", orgPath, dbPath);
            return false;
        }
    }
    
    //open database with FMDB.
    _db = [FMDatabase databaseWithPath:dbPath];
    return [_db open];
}

- (NSArray*)getAll:(NSString *)sql:(NSArray *)param {
    //結果格納用配列
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    //クエリ実行
    //FMResultSet *rs = [_db executeQuery:@"select * from test where id = ?",
    //                  [NSNumber numberWithInt:1]];
    FMResultSet *rs = [_db executeQuery:sql withArgumentsInArray:param];
    
    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    //結果の取得(カラム名指定)
    while ([rs next]) {
        //結果格納用オブジェクト
        NSDictionary *dic = [rs resultDictionary];
        //NSLog(@"%@",dic);
        [result addObject:dic];
    }
    //close ResultSet.
    [rs close];
    
    //NSLog(@"%@",result);
    
    return result;
    
}

- (NSDictionary*)getRow:(NSString *)sql:(NSArray *)param {
    FMResultSet *rs = [_db executeQuery:sql withArgumentsInArray:param];
    
    if ([_db hadError]) {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    //結果の取得(カラム名指定)
    while ([rs next]) {
        //結果格納用オブジェクト
        dic = [rs resultDictionary];
        //NSLog(@"%@",dic);
        
        break;
    }
    //close ResultSet.
    [rs close];
    
    return dic;
    
}

- (BOOL)insert:(NSString *)table:(NSDictionary *)data {
    BOOL result = TRUE;
    //トランザクション開始(exclusive)
    [_db beginTransaction];
    
    NSString *sql = @"insert into ";
    sql = [sql stringByAppendingString:table];
    sql = [sql stringByAppendingString:@" ( "];
    
    NSArray *keys = [data allKeys];
    NSMutableArray *value = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [keys count]; i++) {
        sql = [sql stringByAppendingString:[keys objectAtIndex:i]];
        
        //NSLog(@"%d",i);
        //NSLog(@"%d",[keys count]);
        
        if (i+1 >= [keys count]) {
            sql = [sql stringByAppendingString:@")"];
        } else {
            sql = [sql stringByAppendingString:@","];
        }
        
    }
    
    sql = [sql stringByAppendingString:@" values ( "];
    
    for (int i = 0; i < [keys count]; i++) {
        /*
        NSLog(@"key: %@, value: %@\n",
        [keys objectAtIndex:i],
        [data objectForKey:[keys objectAtIndex:i]]);
         
        
        NSString *str = [NSString stringWithFormat:@"%@ = ?,",[keys objectAtIndex:i]];
        
         */
        
        sql = [sql stringByAppendingString:@"?,"];
        [value addObject:[data objectForKey:[keys objectAtIndex:i]]];
    }
    
    
    NSString *template = @")";
    NSRegularExpression *regexp =
    [NSRegularExpression regularExpressionWithPattern:@",$"
                                              options:0
                                                error:nil];
    sql =
    [regexp stringByReplacingMatchesInString:sql
                                     options:0
                                       range:NSMakeRange(0,sql.length)
                                withTemplate:template];
    
    
    //NSLog(@"%@",sql);
    //ステートメントの再利用フラグ
    //おそらくループ内で同一クエリの更新処理を行う場合バインドクエリの準備を何回
    //も実行してしまうのためこのフラグを設定する。
    //このフラグが設定されているとステートメントが再利用される。
    [_db setShouldCacheStatements:YES];
    
    
    //insertクエリ実行(プリミティブ型は使えない)
    //    [_db executeUpdate:@"insert into example values (?, ?, ?, ?)",
    //                                1, 2, @"test", 4.1];
    // executeUpdateWithFormatメソッドで可能。
    [_db executeUpdate:sql withArgumentsInArray:value];
    
    //check
    if ([_db hadError]) {
        result = FALSE;
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    //commit
    [_db commit];
    
    return result;
}

- (BOOL)update:(NSString *)table:(NSDictionary *)data:(NSDictionary *)where {
    BOOL result = TRUE;
    //トランザクション開始(exclusive)
    [_db beginTransaction];
    
    NSString *sql = @"update ";
    sql = [sql stringByAppendingString:table];
    sql = [sql stringByAppendingString:@" set "];
    
    NSArray *keys = [data allKeys];
    NSMutableArray *value = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [keys count]; i++) {
        NSString *str = [NSString stringWithFormat:@"%@ = ?,",[keys objectAtIndex:i]];
        sql = [sql stringByAppendingString:str];
        [value addObject:[data objectForKey:[keys objectAtIndex:i]]];
    }
    
    
    NSString *template = @"";
    NSRegularExpression *regexp =
    [NSRegularExpression regularExpressionWithPattern:@",$"
                                              options:0
                                                error:nil];
    sql =
    [regexp stringByReplacingMatchesInString:sql
                                     options:0
                                       range:NSMakeRange(0,sql.length)
                                withTemplate:template];
    
    sql = [sql stringByAppendingString:@" where "];
    
    NSArray *wkeys = [where allKeys];
    
    for (int i = 0; i < [keys count]; i++) {
        NSString *str = [NSString stringWithFormat:@"%@ = ? ",[wkeys objectAtIndex:i]];
        if (i+1 < [wkeys count]) {
            sql = [sql stringByAppendingString:@"and "];
        }
        
        sql = [sql stringByAppendingString:str];
        [value addObject:[where objectForKey:[wkeys objectAtIndex:i]]];
    }
    
    //NSLog(@"%@",sql);
    
    //ステートメントの再利用フラグ
    //おそらくループ内で同一クエリの更新処理を行う場合バインドクエリの準備を何回
    //も実行してしまうのためこのフラグを設定する。
    //このフラグが設定されているとステートメントが再利用される。
    [_db setShouldCacheStatements:YES];
    
    
    //insertクエリ実行(プリミティブ型は使えない)
    //    [_db executeUpdate:@"insert into example values (?, ?, ?, ?)",
    //                                1, 2, @"test", 4.1];
    // executeUpdateWithFormatメソッドで可能。
    [_db executeUpdate:sql withArgumentsInArray:value];
    
    //check
    if ([_db hadError]) {
        result = FALSE;
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    //commit
    [_db commit];
    
    return result;
}




@end
