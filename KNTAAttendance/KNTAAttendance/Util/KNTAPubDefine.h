//
//  KNTAPubDefine.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/26.
//  Copyright © 2018年 Kevin. All rights reserved.
//


//标准上班时间
#define kStandardUptime @"09:00"

//标准开始计算加班的时间
#define kStartOverMoment @"19:00"

//每天的红线下班时间_key
#define K_KEY_OFFMOMENT_RED_DAY @"K_KEY_OFFMOMENT_RED_DAY"

//月红线下班时间_key
#define K_KEY_OFFMOMENT_RED_MONTH @"K_KEY_OFFMOMENT_RED_MONTH"

//每天标准开始计算加班时间的时刻_key
#define K_KEY_OFFMOMENT_STANDARD @"K_KEY_OFFMOMENT_STANDARD"

//当天时间是否参与计算_key
#define K_KEY_MOMENTJOINACCOCULATE @"K_KEY_MOMENTJOINACCOCULATE"

//当天没有上班时间是否进行提示
#define K_KEY_ISPROMPTWITHOUTUPTIME @"K_ISPROMPTWITHOUTUPTIME_STORAGE"

//每天的红线下班时间
#define K_OFFMOMENT_RED_DAY_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_RED_DAY];
#define K_SET_OFFMOMENT_RED_DAY_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_RED_DAY];

//月红线下班时间
#define K_OFFMOMENT_RED_MONTH_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_RED_MONTH];
#define K_SET_OFFMOMENT_RED_MONTH_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_RED_MONTH];

//每天标准开始计算加班时间的时刻
#define K_OFFMOMENT_STANDARD_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_STANDARD];
#define K_SET_OFFMOMENT_STANDARD_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_STANDARD];

//当天时间是否参与计算
#define K_MOMENTJOINACCOCULATE_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_MOMENTJOINACCOCULATE];
#define K_SET_MOMENTJOINACCOCULATE_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_MOMENTJOINACCOCULATE];

//当天时间没有上班时间是否进行提示
#define K_ISPROMPTWITHOUTUPTIME_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_ISPROMPTWITHOUTUPTIME];
#define K_SET_ISPROMPTWITHOUTUPTIME_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_ISPROMPTWITHOUTUPTIME];

//取第一天打卡的日期开始计算日历的其实日期
//#define kStartTime [NSDate dateWithTimeIntervalSince1970:1532826729]
#define kStartTime [[NSUserDefaults standardUserDefaults] objectForKey:@"KNTAAttendanceStartTime"];
#define kSetStartTime if (![[NSUserDefaults standardUserDefaults] objectForKey:@"KNTAAttendanceStartTime"]) {\
                            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"KNTAAttendanceStartTime"];\
                        }

