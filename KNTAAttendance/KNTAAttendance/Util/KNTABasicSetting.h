//
//  KNTABasicSetting.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/26.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNTABasicSetting : NSObject


+ (KNTABasicSetting *)sharedInstance;

//平均红线下班时间
@property (strong, nonatomic) NSString *dayRedOffMoment;
//月红线下班时间
@property (strong, nonatomic) NSString *monthRedOffMoment;
//每天标准时间,开始计算加班的时间
@property (strong, nonatomic) NSString *dayStandardOvertimeStartMoment;
//点击四次当天时间不进入统计
@property (assign, nonatomic) BOOL doubleClickForEdit;
//当天没有下班时间是否提示
@property (assign, nonatomic) BOOL promptWithoutUptime;
//是否展示以后的能达到预期平均下班时间的每天的下班时间
@property (assign, nonatomic) BOOL showNextTargetMoment;
//当月预期下班时间
@property (strong, nonatomic) NSString *monthTargetOffMoment;

@end
