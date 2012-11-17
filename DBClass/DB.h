//
//  DB.h
//  DB
//
//  Created by 遠藤 秀春 on 12/11/17.
//  Copyright (c) 2012年 HaruzoWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject

//DB接続
- (BOOL)openDatabase;
//リストで取得
- (NSArray*)getAll:(NSString *)sql:(NSArray *)param;
//1行取得
- (NSDictionary*)getRow:(NSString *)sql:(NSArray *)param;
//インサート
- (BOOL)insert:(NSString *)table:(NSDictionary *)data;
//アップート
- (BOOL)update:(NSString *)table:(NSDictionary *)data:(NSDictionary *)where;

@end
