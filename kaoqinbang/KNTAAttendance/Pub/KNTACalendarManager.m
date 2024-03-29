//
//  KNTACalendarManager.m
//  TestReactiveCocoa
//
//  Created by Kevin on 2018/7/11.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTACalendarManager.h"
#import "KNTAMonthModel.h"
#import "KNTADayData+CoreDataProperties.h"
#import "KNTARecordManager.h"
#import "KNTABasicSetting.h"
#import "KNTAPubDefine.h"
#import "KNTANextManager.h"
#import "KNTANextDayData+CoreDataProperties.h"

@interface KNTACalendarManager ()

@property (strong, nonatomic) NSCalendar *greCalendar;

@property (strong, nonatomic) NSDate *todayDate;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDateComponents *todayComponents;

@property (strong, nonatomic) NSDateComponents *startComponents;


@end

@implementation KNTACalendarManager

- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
}


- (NSArray *)calendarData
{
    self.todayDate = [NSDate date];
    self.greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.todayComponents = [self dateComponents:_todayDate];
    self.startComponents = [self dateComponents:_startDate];
    
    if (!_startDate || (_startComponents.year > _todayComponents.year && _startComponents.month > _todayComponents.month && _startComponents.day > _todayComponents.day)) {
        return nil;
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    NSInteger months = [self limitMonths];
    
    NSArray *arr = [self calenDate:months];
    
    return arr;
}

/*
 NSCalendarUnitEra
 NSCalendarUnitYear
 NSCalendarUnitMonth
 NSCalendarUnitDay
 NSCalendarUnitHour
 NSCalendarUnitMinute
 NSCalendarUnitSecond
 NSCalendarUnitWeekday
 */
//date=>dateComponents
- (NSDateComponents *)dateComponents:(NSDate *)date
{
    NSDateComponents *dateComponents = [_greCalendar components:NSCalendarUnitEra |
                                        NSCalendarUnitYear |
                                        NSCalendarUnitMonth |
                                        NSCalendarUnitWeekOfMonth |
                                        NSCalendarUnitWeekday |
                                        NSCalendarUnitDay |
                                        NSCalendarUnitHour |
                                        NSCalendarUnitMinute |
                                        NSCalendarUnitSecond
                                                       fromDate:date];
    
    return dateComponents;
}

//dateComponents => date
- (NSDate *)dateByDateComponents:(NSDateComponents *)dateComponents
{
    NSDate *date = [_greCalendar dateFromComponents:dateComponents];
    return date;
}

//两个日期之前相差几个月
- (NSInteger)limitMonths
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:_startDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:_startDate];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *monthStart = [NSString stringWithFormat:@"%@-%@-01 00:00:00", year, month];
    NSDate *date = [self.dateFormatter dateFromString:monthStart];
    
    NSDateComponents *dateComponents = [self.greCalendar components:NSCalendarUnitMonth fromDate:date toDate:_todayDate options:0];
    NSInteger months = dateComponents.month;
    return months;;
}

- (NSString *)season:(NSString *)month
{
    NSString *result = nil;
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

//某个月有多少天
- (NSUInteger)dayCountInMonth:(NSDate *)date
{
    NSRange range = [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

//当月第一天是星期几
- (NSUInteger)weekdayInMonth:(NSDate *)date
{
    NSDate *startDate = nil; NSTimeInterval interval = 0; NSUInteger index = 0;
    BOOL result = [_greCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&interval forDate:date];
    if (result) {
        index = [_greCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:startDate];
    }
    return index;
}

//农历
- (NSString *)chineseDayByDate:(NSDate *)date
{
    NSCalendar *chineseCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSArray *month = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                       @"九月", @"十月", @"冬月", @"腊月"];
    NSArray *days = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                      @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                      @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    
    NSDateComponents *dateComponents = [chineseCalender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

    NSString *day = days[dateComponents.day - 1];
    if (dateComponents.day == 1) {
        day = month[dateComponents.month - 1];
    }
    return day;
}

//阳历节日
- (NSString *)gregorianHoliday:(NSDate *)date
{
    NSString *result = nil;
    
    NSDateComponents *components = [self dateComponents:date];
    
    if(components.month == 1 && components.day == 1)
    {
        result = @"元旦";
    }
    else if(components.month == 2 && components.day == 14)
    {
        result = @"情人节";
    }
    else if(components.month == 3 && components.day == 8)
    {
        result = @"妇女节";
    }
    else if(components.month == 4 && components.day == 1)
    {
        result = @"愚人节";
    }
    else if(components.month == 5 && components.day == 1)
    {
        result = @"劳动节";
    }
    else if(components.month == 5 && components.day == 4)
    {
        result = @"青年节";
    }
    else if(components.month == 6 && components.day == 1)
    {
        result = @"儿童节";
    }
    else if(components.month == 8 && components.day == 1)
    {
        result = @"建军节";
    }
    else if(components.month == 9 && components.day == 10)
    {
        result = @"教师节";
    }
    else if(components.month == 10 && components.day == 1)
    {
        result = @"国庆节";
    }
    else if(components.month == 1 && components.day == 1)
    {
        result = @"元旦";
    }
    else if(components.month == 12 && components.day == 25)
    {
        result = @"圣诞节";
    } else if (components.month == 4) {
        
        NSArray *coefficient = @[@5.15, @5.37, @5.59, @4.82, @5.02, @5.26, @5.48, @4.70, @4.92, @5.135, @5.36, @4.60, @4.81, @5.04,
                                 @5.26];
        int mod = components.year % 100;
        int day = (mod * 0.2422 + [coefficient[components.year / 100 - 17] floatValue] - mod / 4);
        if (components.day == day) {
            result = @"清明节";
        }
    }
    
    return result;
}

//农历节日
- (NSString *)chineseHoliday:(NSDate *)date
{
    NSString *result = nil;
    
    NSCalendar *chineseCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *dateComponents = [chineseCalender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    if (dateComponents.month == 1 && dateComponents.day == 1) {
        result = @"春节";
    } else if (dateComponents.month == 1 && dateComponents.day == 15) {
        result = @"元宵节";
    } else if (dateComponents.month == 5 && dateComponents.day == 5) {
        result = @"端午节";
    } else if (dateComponents.month == 7 && dateComponents.day == 7) {
        result = @"七夕节";
    } else if (dateComponents.month == 8 && dateComponents.day == 15) {
        result = @"中秋节";
    } else if (dateComponents.month == 9 && dateComponents.day == 9) {
        result = @"重阳节";
    } else if (dateComponents.month == 12 && dateComponents.day == 30) {
        result = @"除夕";
    }
    
    return result;
}

- (NSString *)holidayByDate:(NSDate *)date
{
    NSString *result = nil;
    
    result = [self gregorianHoliday:date];
    
    NSString *chineseHoliday = [self chineseHoliday:date];
    if (chineseHoliday) {
        result = chineseHoliday;
    }
    
    return result;
}

- (NSArray *)detaildata:(NSDate *)date
{
    NSUInteger dayCount = [self dayCountInMonth:date];
    NSUInteger index = [self weekdayInMonth:date];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSDateComponents *dateComponents = [self dateComponents:date];
    dateComponents.day = 0;
    
    long expectOverTime = 0;
    NSString *expectMoment = [self nextMonthOffMomentOverTime:&expectOverTime];
    for (int i = 0; i < dayCount + index - 1; i++) {
        
        KNTACalendarModel *model = [[KNTACalendarModel alloc] init];
        //空出当月第一天之前不顶格的部分
        if (i < index - 1) {
            [array addObject:model];
            continue;
        }
        dateComponents.day++;
        
        NSDate *mutableDate = [self dateByDateComponents:dateComponents];
        [self.dateFormatter setDateFormat:@"yyyy"];
        NSString *year = [self.dateFormatter stringFromDate:mutableDate];
        model.year = year;
        [self.dateFormatter setDateFormat:@"MM"];
        NSString *month = [self.dateFormatter stringFromDate:mutableDate];
        model.month = month;
        model.season = [self season:month];
        [self.dateFormatter setDateFormat:@"dd"];
        NSString *day = [self.dateFormatter stringFromDate:mutableDate];
        model.day = day;
        model.chineseDay = [self chineseDayByDate:mutableDate];
        model.holiday = [self holidayByDate:mutableDate];
        
        KNTADayData *dayData = [KNTARecordManager object:MAXBSIZE predicate:@"year=\'%@\' && month=\'%@\' && day=\'%@\'", year, month, day].firstObject;
        
        if (dateComponents.year == _todayComponents.year && dateComponents.month == _todayComponents.month && (dateComponents.day) > _todayComponents.day) {
            //超过今天
            if (![KNTABasicSetting sharedInstance].showNextTargetMoment ||
                ![KNTABasicSetting sharedInstance].monthTargetOffMoment ||
                [self compare:[KNTABasicSetting sharedInstance].monthTargetOffMoment desTime:[self monthOffMoment:[NSDate date]]]) {
                
                break;
            }
            
            
            KNTANextDayData *nextDayInfo = [KNTANextManager objectByPredicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day].firstObject;
            if (nextDayInfo.isRestday) {
                
            } else {
                model.targetOffMoment = expectMoment;
                NSInteger time = [self customOverTime:expectOverTime];
                model.overTime = [self archiveTime:time];
            }
            
        } else if (dateComponents.year == _todayComponents.year && dateComponents.month == _todayComponents.month && (dateComponents.day) == _todayComponents.day) {
            //等于今天
            model.upMoment = dayData.upMoment;
            model.offMoment = dayData.offMonment;
            if (model && model.offMoment) {
                NSInteger time = [self customOverTime:dayData.overTime];
                model.overTime = [self archiveTime:time];
            } else if (model) {
                
                if (![KNTABasicSetting sharedInstance].showNextTargetMoment ||
                    ![KNTABasicSetting sharedInstance].monthTargetOffMoment ||
                    [self compare:[KNTABasicSetting sharedInstance].monthTargetOffMoment desTime:[self monthOffMoment:[NSDate date]]]) {
                    
                } else {
                    KNTANextDayData *nextDayInfo = [KNTANextManager objectByPredicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day].firstObject;
                    if (nextDayInfo.isRestday) {
                        
                    } else {
                        model.targetOffMoment = expectMoment;
                        NSInteger time = [self customOverTime:expectOverTime];
                        model.overTime = [self archiveTime:time];
                    }
                }
            }
            model.isInclude = dayData.isInclude;
        } else {
            //之前
            model.upMoment = dayData.upMoment;
            model.offMoment = dayData.offMonment;
            if (model && model.offMoment) {
                NSInteger time = [self customOverTime:dayData.overTime];
                model.overTime = [self archiveTime:time];
            }
            model.isInclude = dayData.isInclude;
        }
        
        [array addObject:model];
    }
    
    NSArray *arr = [NSArray arrayWithArray:array];
    return arr;
}

- (NSArray *)calenDate:(NSInteger)limitMonths
{
    NSDateComponents *dateComponents = [self dateComponents:_todayDate];
    dateComponents.month -= limitMonths;
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < (limitMonths + 1); i++) {
        NSDate *date = [self dateByDateComponents:dateComponents];
        
        KNTAMonthModel *model = [[KNTAMonthModel alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy"];
        model.year = [self.dateFormatter stringFromDate:date];
        [self.dateFormatter setDateFormat:@"MM"];
        NSString *month = [self.dateFormatter stringFromDate:date];
        model.month = month;
        model.season = [self season:month];
        
        model.calendarArray = [self detaildata:date];
        
//        model.monthOffMoment = [self monthOffMoment:date];
//        model.monthUpMoment = [self monthUpMoment:date];
        [self caculateMonthData:date data:&model];
//        model.seasonOffMoment = [self seasonOffMoment:date];
//        model.seasonUpMoment = [self seasonUpMoment:date];
        [self caculateSeasonData:date data:&model];
//        model.yearOffMoment = [self yearOffMoment:date];
//        model.yearUpMoment = [self yearUpMoment:date];
        [self caculateYearData:date data:&model];
        model.monthOverTime = [self monthAverOvertime:date];
        [data addObject:model];
        
        dateComponents.month++;
    }
    NSArray *array = [NSArray arrayWithArray:data];
    return array;
}


#pragma mark // 计算时间
//当月剩余天的预计时间
- (NSString *)nextMonthOffMomentOverTime:(long *)overTime
{
    NSDate *currentDate = [NSDate date];
    
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    [self.dateFormatter setDateFormat:@"dd"];
    NSString *day = [self.dateFormatter stringFromDate:currentDate];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *archiveDateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    currentDate = [self.dateFormatter dateFromString:archiveDateStr];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\'", year, month];
    KNTADayData *currentDayData = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\' && day = %@", year, month, day].firstObject;
    KNTANextDayData *todayEData = [KNTANextManager objectByPredicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day].firstObject;
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.offMonment || !dayData.isInclude) {
            continue;
        }
        index++;
        
        totalTime += dayData.overTime;
    }
    
    NSString *expectMoment = [KNTABasicSetting sharedInstance].monthTargetOffMoment;
    NSDate *expectDate = [self.dateFormatter dateFromString:expectMoment];
    NSTimeInterval interval = [expectDate timeIntervalSinceDate:standardOffDate];
    
    NSUInteger dayCount = [self dayCountInMonth:currentDate];
    NSInteger lastWorkDayCount = dayCount - [day intValue];
    NSArray *nextInfos = [KNTANextManager objectByPredicate:@"year = \'%@\' && month = \'%@\'", year, month];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (KNTANextDayData *data in nextInfos) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", data.year, data.month, data.day];
        NSDate *dataDate = [self.dateFormatter dateFromString:dateStr];
        if ([currentDate compare:dataDate] == NSOrderedAscending && data.isRestday) {
            --lastWorkDayCount;
        }
    }
    
    if ((!currentDayData || !currentDayData.offMonment) &&
        (!todayEData || !todayEData.isRestday)) {
        lastWorkDayCount += 1;
    }
    if (lastWorkDayCount <= 0) {
        return nil;
    }
    NSInteger totalCount = lastWorkDayCount + index;
    
    long totalOverTime = interval * totalCount;
    long lastAverOverTime = (totalOverTime - totalTime) / lastWorkDayCount;
    if (overTime) {
        *overTime = lastAverOverTime;
    }
    NSDate *lastDate = [standardOffDate dateByAddingTimeInterval:lastAverOverTime];
    [self.dateFormatter setDateFormat:@"HH:mm"];
    NSString *offMoment = [self.dateFormatter stringFromDate:lastDate];
    
    return offMoment;
}

- (NSString *)monthOffMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\'", year, month];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.offMonment || !dayData.isInclude) {
            continue;
        }
        index++;
        
//        if (dayData.overTime > 0) {
            totalTime += dayData.overTime;
//        } else {
//            NSDate *offDate = [self.dateFormatter dateFromString:dayData.offMonment];
//
//            long interval = [offDate timeIntervalSinceDate:standardOffDate];
//            totalTime += interval;
//        }
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        return offMoment;
    }
    return nil;
    
}

- (NSString *)monthUpMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\'", year, month];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.upMoment || !dayData.isInclude) {
            continue;
        }
        index++;
        
        NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
        
        long interval = [upDate timeIntervalSinceDate:standardUpDate];
        totalTime += interval;
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        return upMoment;
    }
    return nil;
}


- (void)caculateMonthData:(NSDate *)currentDate data:(KNTAMonthModel **)data
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\'", year, month];
    
    NSInteger upIndex = 0; NSInteger offIndex = 0; long upTotalTime = 0; long offTotalTime = 0; long turnoutDays = 0; long effectiveDays = 0; long durationDays = 0; double duration = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    for (KNTADayData *dayData in dayDatas) {
        
        turnoutDays++;
        if (!dayData.isInclude) {
            continue;
        }
        effectiveDays++;
        if (dayData.upMoment) {
            upIndex++;
            
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            long interval = [upDate timeIntervalSinceDate:standardUpDate];
            upTotalTime += interval;
        }
        
        if (dayData.offMonment) {
            offIndex++;
            offTotalTime += dayData.overTime;
        }
        
        if (dayData.upMoment && dayData.offMonment) {
            ++durationDays;
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            NSDate *offDate = [standardOffDate dateByAddingTimeInterval:dayData.overTime];
            NSTimeInterval interval = [offDate timeIntervalSinceDate:upDate];
            duration += interval;
        }
    }
    
    (*data).turnOutDaysOfMonth = [NSString stringWithFormat:@"%ld", (long)turnoutDays];
    (*data).effectiveDaysOfMonth = [NSString stringWithFormat:@"%ld", (long)effectiveDays];
    
    if (upIndex != 0) {
        NSInteger averTime = upTotalTime / upIndex;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        (*data).monthUpMoment = upMoment;
    }
    
    if (offIndex != 0) {
        NSInteger averTime = offTotalTime / offIndex;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        (*data).monthOffMoment = offMoment;
    }
    
    if (durationDays != 0) {
        NSInteger aveD = (duration / durationDays);
        (*data).averDurationOfMonth = [self archiveTime:aveD];
    }
}


- (NSString *)seasonOffMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    NSString *season = [self season:month];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && season = \'%@\'", year, season];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.offMonment || !dayData.isInclude) {
            continue;
        }
        index++;
        
//        if (dayData.overTime > 0) {
            totalTime += dayData.overTime;
//        } else {
//            NSDate *offDate = [self.dateFormatter dateFromString:dayData.offMonment];
//
//            long interval = [offDate timeIntervalSinceDate:standardOffDate];
//            totalTime += interval;
//        }
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        return offMoment;
    }
    return nil;

}

- (NSString *)seasonUpMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    NSString *season = [self season:month];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && season = \'%@\'", year, season];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.upMoment || !dayData.isInclude) {
            continue;
        }
        index++;
        
        
        NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
        
        long interval = [upDate timeIntervalSinceDate:standardUpDate];
        totalTime += interval;
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        return upMoment;
    }
    return nil;
    
}


- (void)caculateSeasonData:(NSDate *)currentDate data:(KNTAMonthModel **)data
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    NSString *season = [self season:month];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && season = \'%@\'", year, season];
    
    NSInteger upIndex = 0; NSInteger offIndex = 0; long upTotalTime = 0; long offTotalTime = 0; long turnoutDays = 0; long effectiveDays = 0; long durationDays = 0; double duration = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    for (KNTADayData *dayData in dayDatas) {
        
        turnoutDays++;
        if (!dayData.isInclude) {
            continue;
        }
        effectiveDays++;
        if (dayData.upMoment) {
            upIndex++;
            
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            long interval = [upDate timeIntervalSinceDate:standardUpDate];
            upTotalTime += interval;
        }
        
        if (dayData.offMonment) {
            offIndex++;
            offTotalTime += dayData.overTime;
        }
        
        if (dayData.upMoment && dayData.offMonment) {
            ++durationDays;
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            NSDate *offDate = [standardOffDate dateByAddingTimeInterval:dayData.overTime];
            NSTimeInterval interval = [offDate timeIntervalSinceDate:upDate];
            duration += interval;
        }
    }
    
    (*data).turnOutDaysOfSeason = [NSString stringWithFormat:@"%ld", (long)turnoutDays];
    (*data).effectiveDaysOfSeason = [NSString stringWithFormat:@"%ld", (long)effectiveDays];
    
    if (upIndex != 0) {
        NSInteger averTime = upTotalTime / upIndex;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        (*data).seasonUpMoment = upMoment;
    }
    
    if (offIndex != 0) {
        NSInteger averTime = offTotalTime / offIndex;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        (*data).seasonOffMoment = offMoment;
    }
    
    if (durationDays != 0) {
        NSInteger aveD = (duration / durationDays);
        (*data).averDurationOfSeason = [self archiveTime:aveD];
    }
}

- (NSString *)yearOffMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\'", year];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.offMonment || !dayData.isInclude) {
            continue;
        }
        index++;
        
//        if (dayData.overTime > 0) {
            totalTime += dayData.overTime;
//        } else {
//            NSDate *offDate = [self.dateFormatter dateFromString:dayData.offMonment];
//
//            long interval = [offDate timeIntervalSinceDate:standardOffDate];
//            totalTime += interval;
//        }
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        return offMoment;
    }
    return nil;
    
}

- (NSString *)yearUpMoment:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\'", year];
    
    NSInteger index = 0; long totalTime = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.upMoment || !dayData.isInclude) {
            continue;
        }
        index++;
        
        
        NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
        
        long interval = [upDate timeIntervalSinceDate:standardUpDate];
        totalTime += interval;
    }
    
    if (index != 0) {
        NSInteger averTime = totalTime / index;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        return upMoment;
    }
    return nil;
    
}


- (void)caculateYearData:(NSDate *)currentDate data:(KNTAMonthModel **)data
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\'", year];
    
    NSInteger upIndex = 0; NSInteger offIndex = 0; long upTotalTime = 0; long offTotalTime = 0; long turnoutDays = 0; long effectiveDays = 0; long durationDays = 0; double duration = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *standardOffDate = [self.dateFormatter dateFromString:kStartOverMoment];
    NSDate *standardUpDate = [self.dateFormatter dateFromString:kStandardUptime];
    for (KNTADayData *dayData in dayDatas) {
        
        turnoutDays++;
        if (!dayData.isInclude) {
            continue;
        }
        effectiveDays++;
        if (dayData.upMoment) {
            upIndex++;
            
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            long interval = [upDate timeIntervalSinceDate:standardUpDate];
            upTotalTime += interval;
        }
        
        if (dayData.offMonment) {
            offIndex++;
            offTotalTime += dayData.overTime;
        }
        
        if (dayData.upMoment && dayData.offMonment) {
            ++durationDays;
            NSDate *upDate = [self.dateFormatter dateFromString:dayData.upMoment];
            NSDate *offDate = [standardOffDate dateByAddingTimeInterval:dayData.overTime];
            NSTimeInterval interval = [offDate timeIntervalSinceDate:upDate];
            duration += interval;
        }
    }
    
    (*data).turnOutDaysOfYear = [NSString stringWithFormat:@"%ld", (long)turnoutDays];
    (*data).effectiveDaysOfYear = [NSString stringWithFormat:@"%ld", (long)effectiveDays];
    
    if (upIndex != 0) {
        NSInteger averTime = upTotalTime / upIndex;
        NSDate *date = [standardUpDate dateByAddingTimeInterval:averTime];
        NSString *upMoment = [self.dateFormatter stringFromDate:date];
        (*data).yearUpMoment = upMoment;
    }
    
    if (offIndex != 0) {
        NSInteger averTime = offTotalTime / offIndex;
        NSDate *date = [standardOffDate dateByAddingTimeInterval:averTime];
        NSString *offMoment = [self.dateFormatter stringFromDate:date];
        (*data).yearOffMoment = offMoment;
    }
    
    if (durationDays != 0) {
        NSInteger aveD = (duration / durationDays);
        (*data).averDurationOfYear = [self archiveTime:aveD];
    }
}


- (NSString *)monthAverOvertime:(NSDate *)currentDate
{
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:currentDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:currentDate];
    
    NSArray *dayDatas = [KNTARecordManager object:MAXBSIZE predicate:@"year = \'%@\' && month = \'%@\'", year, month];
    
    NSInteger index = 0; long totalTime = 0;
    for (KNTADayData *dayData in dayDatas) {
        if (!dayData.isInclude || !dayData.offMonment) {
            continue;
        }
        index++;
        if (dayData.overTime > 0) {
            totalTime += dayData.overTime;
        }
    }
    
    if (index != 0) {
        NSInteger averOvertime = totalTime / index;
        NSString *overTime = [self archiveTime:averOvertime];
        return overTime;
    }
    return nil;
}

- (NSString *)archiveTime:(NSInteger)time
{
    if (time <= 0) {
        return nil;
    }
    
    NSInteger minutes = time / 60;
    
    NSString *minute = (minutes % 60 > 0) ? [NSString stringWithFormat:@"%ld分钟", (minutes % 60)] : @"";
    NSInteger hours = minutes / 60;
    NSString *hour = (hours % 24) > 0 ? [NSString stringWithFormat:@"%ld小时", (hours % 24)] : @"";
    NSInteger days = hours / 24;
    NSString *day = days > 0 ? [NSString stringWithFormat:@"%ld天", days] : @"";
    
    NSString *overTime = [NSString stringWithFormat:@"%@%@%@", day, hour, minute];
    return overTime;
    
}

- (NSInteger)customOverTime:(NSInteger)time
{
    NSTimeInterval interval = 0;
    self.dateFormatter.dateFormat = @"HH:mm";
    NSString *str = [KNTABasicSetting sharedInstance].dayStandardOvertimeStartMoment;
    NSDate *customStandardOverMoment = [self.dateFormatter dateFromString:str];
    if (customStandardOverMoment) {
        NSDate *standardOverMoment = [self.dateFormatter dateFromString:kStartOverMoment];
        interval = [standardOverMoment timeIntervalSinceDate:customStandardOverMoment];
    }
    
    NSInteger customTime = time + interval;
    
    return customTime;
}

- (BOOL)compare:(NSString *)time desTime:(NSString *)desTime
{
    BOOL isOver = NO;
    
    self.dateFormatter.dateFormat = @"HH:mm";
    NSDate *date = [self.dateFormatter dateFromString:time];
    NSDate *desDate = [self.dateFormatter dateFromString:desTime];
    
    if ([date compare:desDate] == NSOrderedAscending) {
        isOver = YES;
    }
    return isOver;
}


@end
