//
//  KNTAMonthModel.h
//  TestReactiveCocoa
//
//  Created by Kevin on 2018/7/11.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNTAMonthModel : NSObject

@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSString *season;

@property (strong, nonatomic) NSString *month;

@property (strong, nonatomic) NSString *yearUpMoment;
@property (strong, nonatomic) NSString *seasonUpMoment;
@property (strong, nonatomic) NSString *monthUpMoment;

@property (strong, nonatomic) NSString *yearOffMoment;
@property (strong, nonatomic) NSString *seasonOffMoment;
@property (strong, nonatomic) NSString *monthOffMoment;

@property (strong, nonatomic) NSString *monthOverTime;

@property (strong, nonatomic) NSArray *calendarArray;

@end


@interface KNTACalendarModel : NSObject

@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSString *season;

@property (strong, nonatomic) NSString *month;

@property (strong, nonatomic) NSString *day;

@property (strong, nonatomic) NSString *chineseDay;

@property (strong, nonatomic) NSString *holiday;

@property (strong, nonatomic) NSString *upMoment;

@property (strong, nonatomic) NSString *offMoment;

@property (strong, nonatomic) NSString *overTime;

@property (assign, nonatomic) BOOL isInclude;

@end
