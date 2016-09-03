//
//  HMJSchoolTool.h
//  HMJSearchBar
//
//  Created by MJHee on 16/9/2.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMJSchool;

@interface HMJSchoolTool : NSObject
/**
 *  保存一个学校
 */
+ (void)save:(HMJSchool *)school;

/**
 *  查询所有的学校
 */
+ (NSArray *)query;
+ (NSArray *)queryWithCondition:(NSString *)condition;
+ (void)deleteTable;

@end
