//
//  HMJSchoolTool.m
//  HMJSearchBar
//
//  Created by MJHee on 16/9/2.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "HMJSchoolTool.h"
#import "HMJSchool.h"
#import <sqlite3.h>

@implementation HMJSchoolTool

static sqlite3 *_db;

+ (void)initialize {
    //获得数据库文件的路径
    NSString *doc      = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"school.sqlite"];
    NSLog(@"fileName = %@", fileName);
    //将OC字符串转换成C语言的字符串
    const char *cfileName = fileName.UTF8String;

    //1.打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    int result = sqlite3_open(cfileName, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"成功打开数据库");

        //2.创建表(如果要修改表,那么需要将目录下的数据库文件删除掉,否则将插入数据失败)
        const char *sql = "CREATE TABLE IF NOT EXISTS t_school (id int PRIMARY KEY,name text NOT NULL)";
        char *errmsg    = NULL;
        result = sqlite3_exec(_db, sql, NULL, NULL, &errmsg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创建表");
        } else{
            NSLog(@"创建表失败 -- %s", errmsg);
        }
    } else{
        NSLog(@"打开数据库失败");
    }
}

+ (void)deleteTable {
    //1.拼接SQL语句
    NSString *sql = @"DROP TABLE t_school;";
    NSLog(@"sql = %@", sql);
    //2.执行SQL语句
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"删除表失败 -- %s", errmsg);
    } else{
        NSLog(@"成功删除表");
    }
}

+ (void)save:(HMJSchool *)school {
    //1.拼接SQL语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_school (id,name) VALUES (%d,'%@');", school.ID, school.name];
    NSLog(@"sql = %@", sql);
    //2.执行SQL语句
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入数据失败 -- %s", errmsg);
    } else{
        NSLog(@"插入数据成功");
    }
}

+ (NSArray *)query {
    return [self queryWithCondition:@""];
}

//模糊查询
+ (NSArray *)queryWithCondition:(NSString *)condition {
    //数组,用来存放所有查询到的学校
    NSMutableArray *schools = nil;
    NSString *NSsql;
    if (condition.length > 0) {

        NSsql = [NSString stringWithFormat:@"SELECT id,name FROM t_school WHERE name like '%%%@%%';", condition];
        NSLog(@"SQL = %@", NSsql);
    } else{

        NSsql = @"SELECT id,name FROM t_school;";
        NSLog(@"SQL = %@", NSsql);
    }
    const char *sql = NSsql.UTF8String;


    sqlite3_stmt *stmt = NULL;

    //进行查询前的准备工作
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没有问题");

        schools = [NSMutableArray array];

        //每调用一次sqlite3_step函数,stmt就会指向下一条记录
        NSLog(@"sqlite3_step(stmt) = %d", sqlite3_step(stmt));
        while (sqlite3_step(stmt) == 100 || sqlite3_step(stmt) == SQLITE_OK) {
            //找到一条记录

            //取出数据
            //(1)取出第0列字段的值(int类型的值)
            int ID = sqlite3_column_int(stmt, 0);
            //(2)取出第1列字段的值(text类型的值)
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            HMJSchool *school = [[HMJSchool alloc] init];
            school.ID   = ID;
            school.name = [NSString stringWithUTF8String:(const char *)name];
            [schools addObject:school];
            NSLog(@"schools = %@", schools);
        }
    } else{
        NSLog(@"查询语句有问题");
    }
    return schools;
}

@end
