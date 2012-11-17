//
//  ViewController.m
//  DB
//
//  Created by 遠藤 秀春 on 12/11/17.
//  Copyright (c) 2012年 HaruzoWorks. All rights reserved.
//

#import "ViewController.h"
#import "DB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //インスタンス作成
    DB *db = [[DB alloc]init];
    //DB接続
    [db openDatabase];
    
    /*
    //SQL 条件値は?にする
    NSString *sql = @"select * from test where id = ? and name = ? ";
    //?を変換する配列
    NSMutableArray *param = [[NSMutableArray alloc]init];
    //idは3の条件で
    [param addObject:@"2"];
    //nameはtakaizumiの条件で
    [param addObject:@"yasuda"];
    //ゲット
    NSArray *list = [db getAll:sql:param];
    //ログに出してみる
    //NSLog(@"%@",list);
     */
    
    /* インサートする時 */
    /*
    //テーブル名指定
    NSString *table = @"test";
    //ディクショナリ作成
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //idは4を入れてみる
    [dict setObject:@"4" forKey:@"id"];
    //nameはsatomiを入れてみる
    [dict setObject:@"satomi" forKey:@"name"];
    //インサート
    [db insert:table:dict];
     */
    
    /* アップデートする時 */
    //テーブル指定
    NSString *table = @"test";
    //ディクショナリ作成
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //nameをsatoshiに変更する
    [dict setObject:@"satoshi" forKey:@"name"];
    //条件用のディクショナリを作成
    NSMutableDictionary *where = [[NSMutableDictionary alloc]init];
    //条件はidが3ということで。
    [where setObject:@"3" forKey:@"id"];
    //アップデート
    [db update:table:dict:where];
    
    //SQL 条件値は?にする
    NSString *sql = @"select * from test where id = ?";
    //?を変換する配列
    NSMutableArray *param = [[NSMutableArray alloc]init];
    //idは2の条件で
    [param addObject:@"1"];
    //ゲット
    NSDictionary *data = [db getRow:sql:param];
    //ログに出してみる
    NSLog(@"%@",data);
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
