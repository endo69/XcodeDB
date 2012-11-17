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


@end
