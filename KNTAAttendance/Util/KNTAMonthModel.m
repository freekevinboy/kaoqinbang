//
//  KNTAMonthModel.m
//  TestReactiveCocoa
//
//  Created by Kevin on 2018/7/11.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTAMonthModel.h"

@implementation KNTAMonthModel

/*
 year;
 season;
 month;
 calendarArray
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p>\nyear:%@, season:%@, month:%@, calendarArray:%@",[self class], self, _year, _season, _month, _calendarArray];
}

@end

/*
 year;
 season;
 month;
 day;
 chineseDay;
 holiday;
 upTime;
 offTime;
 */

@implementation KNTACalendarModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p>\nyear:%@, season:%@, month:%@, day:%@, chineseDay:%@, holiday:%@, upTime:%@, offTime:%@, ",[self class], self, _year, _season, _month, _day, _chineseDay, _holiday, _upMoment, _offMoment];
}


@end
