//
//  KNTADBManager.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNTADBManager : NSObject

+ (BOOL)insertData:(NSString *)entityName handle:(id(^)(id obj))handle;

+ (id)objFromDB:(NSString *)entityName limit:(NSUInteger)limit predicate:(NSString *)format,...;

+ (BOOL)updateData:(NSString *)entityName limit:(NSUInteger)limit handle:(void(^)(NSArray *array))handle predicate:(NSString *)format,...;

+ (BOOL)deleteData:(NSString *)entityName predicate:(NSString *)format,...;

@end
