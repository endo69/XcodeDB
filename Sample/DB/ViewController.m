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
    
    DB *db = [[DB alloc]init];
    [db openDatabase];
    
    NSString *sql = @"select * from test where id = ? and name = ? ";
    NSMutableArray *param = [[NSMutableArray alloc]init];
    [param addObject:@"3"];
    [param addObject:@"takaizumi"];
    
    NSArray *list = [db getAll:sql:param];
    
    NSLog(@"%@",list);
    
    
    NSString *table = @"test";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"4" forKey:@"id"];
    [dict setObject:@"satomi" forKey:@"name"];
    
    [db insert:table:dict];
     
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
