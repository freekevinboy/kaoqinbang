//
//  KNTANextManager.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/21.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNTANextManager : NSObject


+ (void)insertData:(BOOL)desValue date:(NSDate *)date;

+ (void)updateData:(BOOL)desValue date:(NSDate *)date;

+ (NSArray *)objectByPredicate:(NSString *)format,...;

+ (void)deleteDBData:(NSDate *)date;


@end

NS_ASSUME_NONNULL_END
