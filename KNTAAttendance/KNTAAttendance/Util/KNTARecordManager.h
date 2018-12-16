//
//  KNTARecordManager.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, E_INSERTTYPE) {
    eTypeUp = 3,
    eTypeOff,
};

typedef NS_ENUM(NSUInteger, E_DEALOFFTYPE) {
    eTypeLastUp = 3,
    eTypeCurrentDay,
};


@interface KNTARecordManager : NSObject

+ (void)insertData:(E_INSERTTYPE)eType date:(NSDate *)attendanceDate predicate:(NSDate *)date;

+ (NSArray *)object:(NSUInteger)limitSize predicate:(NSString *)format,...;

+ (void)updateDataType:(E_INSERTTYPE)eType date:(NSDate *)date handle:(E_DEALOFFTYPE(^)(void))handle updateHandle:(void(^)(id obj))updateHandle predicate:(NSString *)format,...;

+ (void)deleteD:(NSDate *)date;

@end
