//
//  KNTARecordManager.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTARecordManager.h"
#import "KNTADBManager.h"
#import "KNTADayData+CoreDataProperties.h"
#import <malloc/malloc.h>
#import "KNTABasicSetting.h"

@interface KNTARecordManager ()

@property (strong, nonatomic) NSCalendar *greCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


static KNTARecordManager *manager = nil;

static int maxCount = 0;

@implementation KNTARecordManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

+ (KNTARecordManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KNTARecordManager alloc] init];
    });
    return manager;
}

+ (void)insertData:(E_INSERTTYPE)eType date:(NSDate *)attendanceDate predicate:(NSDate *)date
{
    kSetStartTime
    
    KNTARecordManager *recordManager = [KNTARecordManager sharedInstance];
    
    recordManager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"MM";
    NSString *month = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"dd";
    NSString *day = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"HH";
    NSString *hour = [recordManager.dateFormatter stringFromDate:attendanceDate];
    recordManager.dateFormatter.dateFormat = @"mm";
    NSString *minutes = [recordManager.dateFormatter stringFromDate:attendanceDate];
    
    [KNTADBManager insertData:@"KNTADayData" handle:^id(KNTADayData *obj) {
        
        obj.year = year;
        obj.month = month;
        obj.day = day;
        obj.season = [KNTARecordManager season:month];
        switch (eType) {
            case eTypeUp:{
                obj.upMoment = [NSString stringWithFormat:@"%@:%@", hour, minutes];
                obj.isInclude = YES;
                break;
            }
            case eTypeOff:{
                obj.offMonment = [NSString stringWithFormat:@"%@:%@", hour, minutes];
                obj.overTime = [KNTARecordManager overTime:obj offDate:attendanceDate];
                obj.isInclude = YES;
                break;
            }
        }
        return obj;
    }];
}

+ (void)updateDataType:(E_INSERTTYPE)eType date:(NSDate *)date handle:(E_DEALOFFTYPE(^)(void))handle updateHandle:(void(^)(id obj))updateHandle predicate:(NSString *)format,...
{
    KNTARecordManager *recordManager = [KNTARecordManager sharedInstance];
    
    recordManager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"MM";
    NSString *month = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"dd";
    NSString *day = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"HH";
    NSString *hour = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"mm";
    NSString *minutes = [recordManager.dateFormatter stringFromDate:date];
    
    NSString *param = nil;
    if (!format) {
        param = [NSString stringWithFormat:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day];
    } else {
        va_list ap;
        va_start(ap, format);
        param = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
        va_end(ap);
    }
    
    [KNTADBManager updateData:@"KNTADayData"
                        limit:MAXBSIZE
                       handle:^(NSArray *array) {
                           if (array.count) {
                               //当天有数据,可以更新数据
                               if (updateHandle) {
                                   for (KNTADayData *data in array) {
                                       updateHandle(data);
                                   }
                                   return;
                               }
                               for (KNTADayData *data in array) {
                                   switch (eType) {
                                       case eTypeUp:{
                                           data.upMoment = [NSString stringWithFormat:@"%@:%@", hour, minutes];
                                           break;
                                       }
                                       case eTypeOff:{
                                           data.offMonment = [NSString stringWithFormat:@"%@:%@", hour, minutes];
                                           data.overTime = [KNTARecordManager overTime:data offDate:date];
                                           break;
                                       }
                                   }
                               }
                           } else if (eType == eTypeOff) {
                               //当天没数据,且此条数据为下班数据
                               
                               NSString *str = [[[[param stringByReplacingOccurrencesOfString:@"year" withString:@""] stringByReplacingOccurrencesOfString:@"month" withString:@""] stringByReplacingOccurrencesOfString:@"day" withString:@""] stringByReplacingOccurrencesOfString:@"\'" withString:@""];
                               recordManager.dateFormatter.dateFormat = @" = yyyy &&  = MM &&  = dd";
                               NSDate *transferDate = [recordManager.dateFormatter dateFromString:str];
                               
                               if (handle) {
                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                       
                                       E_DEALOFFTYPE type = handle();
                                       if (type == eTypeCurrentDay) {
                                           //直接插入到当天
                                           [KNTARecordManager insertData:eTypeOff date:date predicate:transferDate];
                                       } else if (type == eTypeLastUp) {
                                           //超过10天找不到数据的,终止寻找
                                           if (maxCount > 10) {
                                               maxCount = 0;
                                               return;
                                           }
                                           maxCount++;
                                           
                                           //更新到最近的一条有上班数据的
                                           NSDate *newDate = [transferDate dateByAddingTimeInterval:-24*60*60];
                                           recordManager.dateFormatter.dateFormat = @"yyyy";
                                           NSString *newYear = [recordManager.dateFormatter stringFromDate:newDate];
                                           recordManager.dateFormatter.dateFormat = @"MM";
                                           NSString *newMonth = [recordManager.dateFormatter stringFromDate:newDate];
                                           recordManager.dateFormatter.dateFormat = @"dd";
                                           NSString *newDay = [recordManager.dateFormatter stringFromDate:newDate];
                                           NSString *newParam = [NSString stringWithFormat:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", newYear, newMonth, newDay];
                                           
                                           [KNTARecordManager updateDataType:eTypeOff date:date handle:^E_DEALOFFTYPE{
                                               return eTypeLastUp;
                                           } updateHandle:nil predicate:newParam];
                                           
                                       }
                                       
                                   });
                               } else {
                                   [KNTARecordManager insertData:eTypeOff date:date predicate:transferDate];
                               }
                           } else {
                               //当天没数据,且此条数据为上班数据,直接插入该数据
                               [KNTARecordManager insertData:eTypeUp date:date predicate:date];
                           }
                       }
                    predicate:param];
}

+ (NSArray *)object:(NSUInteger)limitSize predicate:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *message = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [KNTADBManager objFromDB:@"KNTADayData" limit:limitSize predicate:message];
}

+ (void)deleteD:(NSDate *)date
{
    KNTARecordManager *recordManager = [KNTARecordManager sharedInstance];
    
    recordManager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"MM";
    NSString *month = [recordManager.dateFormatter stringFromDate:date];
    recordManager.dateFormatter.dateFormat = @"dd";
    NSString *day = [recordManager.dateFormatter stringFromDate:date];
    
    NSString *param = [NSString stringWithFormat:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day];
    [KNTADBManager deleteData:@"KNTADayData" predicate:param];
}

//
+ (int64_t)overTime:(KNTADayData *)dayData offDate:(NSDate *)offDate
{
    if (!offDate) {
        return 0;
    }
    
    KNTARecordManager *recordManager = [KNTARecordManager sharedInstance];

    recordManager.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *upDateString = [NSString stringWithFormat:@"%@-%@-%@ %@", dayData.year, dayData.month, dayData.day, [KNTABasicSetting sharedInstance].dayStandardOvertimeStartMoment];
    NSDate *upDate = [recordManager.dateFormatter dateFromString:upDateString];
    
    if ([upDate compare:offDate] != NSOrderedAscending) {
        return 0;
    }
    
    NSTimeInterval interval = [offDate timeIntervalSinceDate:upDate];
    return interval;
}

+ (NSString *)season:(NSString *)month
{
    NSString *result = @"";
    NSInteger mon = [month integerValue];
    if (mon <= 3 && mon > 0) {
        result = @"1";
    } else if (mon > 3 && mon <= 6) {
        result = @"2";
    } else if (mon > 6 && mon <= 9) {
        result = @"3";
    } else if (mon > 9 && mon <= 12) {
        result = @"4";
    }
    return result;
}

@end
