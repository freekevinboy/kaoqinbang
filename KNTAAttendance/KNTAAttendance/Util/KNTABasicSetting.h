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


@property (strong, nonatomic) NSString *dayRedOffMoment;

@property (strong, nonatomic) NSString *monthRedOffMoment;

@property (strong, nonatomic) NSString *dayStandardOvertimeStartMoment;

@property (assign, nonatomic) BOOL doubleClickForEdit;



@end
