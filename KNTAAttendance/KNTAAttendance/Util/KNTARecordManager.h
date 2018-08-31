//
//  KNTARecordManager.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kStandardUptime @"09:00"

#define kStartTime [NSDate dateWithTimeIntervalSince1970:1532826729]
//#define kStartTime [[NSUserDefaults standardUserDefaults] objectForKey:@"KNTAAttendanceStartTime"];
#define kSetStartTime if (![[NSUserDefaults standardUserDefaults] objectForKey:@"KNTAAttendanceStartTime"]) {\
                                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"KNTAAttendanceStartTime"];\
                            }

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

@end
