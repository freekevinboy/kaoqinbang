//
//  KNTABasicSetting.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/26.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTABasicSetting.h"
#import "KNTAPubDefine.h"


static KNTABasicSetting *setting = nil;

@implementation KNTABasicSetting

+ (void)load
{
    [super load];
    [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *standard = K_OFFMOMENT_STANDARD_STORAGE;
        if (!standard.length) {
            K_SET_OFFMOMENT_STANDARD_STORAGE(kStartOverMoment);
        }
        _dayStandardOvertimeStartMoment = K_OFFMOMENT_STANDARD_STORAGE;
        _dayRedOffMoment = K_OFFMOMENT_RED_DAY_STORAGE;
        _monthRedOffMoment = K_OFFMOMENT_RED_MONTH_STORAGE;
        id obj = K_MOMENTJOINACCOCULATE_STORAGE;
        _doubleClickForEdit = [obj boolValue];
        id propmtObj = K_ISPROMPTWITHOUTUPTIME_STORAGE;
        _promptWithoutUptime = [propmtObj intValue] == 1 || !propmtObj;
        
    }
    return self;
}


+ (KNTABasicSetting *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        setting = [[KNTABasicSetting alloc] init];
    });
    return setting;
}



@end
