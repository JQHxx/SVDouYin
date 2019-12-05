//
//  IDataBase.m
//  Mall
//
//  Created by midland on 2019/8/28.
//  Copyright © 2019 JQHxx. All rights reserved.
//

#import "IDataBase.h"
#import <FMDB.h>

@interface IDataBase()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation IDataBase

static IDataBase *_instance = nil;

+ (instancetype) shareDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IDataBase alloc]init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openDB];
    }
    return self;
}

#pragma mark - Private methods
- (void) openDB {
    // 目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"INetwork.sqlite"];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    [self createTable];
}

- (void) createTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS tb_network (id integer PRIMARY KEY AUTOINCREMENT, url text NOT NULL, data blob NOT NULL,savetime text, cachetime double);";
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeStatements:sql];
    }];
}

#pragma mark - 数据的保存和读取
- (NSData *) queryData: (NSString *) url {
    NSString *sql = @"SELECT * FROM tb_network WHERE url=?;";
    __block NSData *tempData ;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql, url];
        while ([rs next]) {
            NSDate *saveTime = [rs dateForColumn:@"savetime"];
            NSData *data = [rs dataForColumn:@"data"];
            double cacheTime = [rs doubleForColumn:@"cachetime"];
            
            double timeInterval = [saveTime timeIntervalSince1970];
            double tempTime = timeInterval + cacheTime;
            double nowTime = [[NSDate date] timeIntervalSince1970];
            
            if ((cacheTime >= 0 && tempTime >= nowTime) || cacheTime == -1) {
                NSLog(@"%@", @"缓存读取成功");
                tempData = data;
            } else {
                
                NSString *deleteSql = @"DELETE FROM tb_network WHERE url=?;";
                BOOL result = [db executeUpdate:deleteSql, url];
                if (result) {
                    NSLog(@"%@", @"缓存过期 删除");
                }
            }
        }
        [rs close];
    }];
    return tempData;
}

/**
 * 根据url删除数据
 */
- (void) deleteData: (NSString *) url {
    NSString *sql = @"DELETE FROM tb_network WHERE url=?;";
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:sql, url];
    }];
}

// 注意：插入基本类型会报错
- (void) saveData: (NSString *) url data: (NSData *) data cacheTime: (double) cacheTime {
    
    if ([self isAlreadyExist:url]) {
         NSString *updateSql = @"UPDATE tb_network SET data=?,savetime=?,cachetime=? WHERE url=?;";
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL result = [db executeUpdate:updateSql, data, [NSDate date], [NSString stringWithFormat:@"%f", cacheTime], url];
            if (result) {
                NSLog(@"数据更新成功");
            } else {
                NSLog(@"数据更新失败");
            }
        }];
    } else {
        NSString *insertSql = @"INSERT INTO tb_network (url,data,savetime,cachetime) VALUES (?,?,?,?);";
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL result = [db executeUpdate:insertSql, url, data, [NSDate date], [NSString stringWithFormat:@"%f", cacheTime]];
            if (result) {
                NSLog(@"数据插入成功");
            } else {
                NSLog(@"数据插入失败");
            }
        }];
    }
}

- (BOOL) isAlreadyExist: (NSString *) url  {
    NSString *sql = @"SELECT * FROM tb_network WHERE url=? LIMIT 1;";
    __block BOOL isExist = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql, url];
        if ([rs next]) {
            isExist = YES;
        }
        [rs close];
    }];
    return isExist;
}


@end
