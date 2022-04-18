//
//  KNTACalendarController.h
//  TestReactiveCocoa
//
//  Created by Kevin on 2018/7/11.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNTARecordManager.h"

@protocol KNTACalendarUpdateMomentDlegate<NSObject>

- (void)updateMoment:(NSDate *)date type:(E_INSERTTYPE)eType;

@end

@interface KNTACalendarController : UIViewController


@property(weak, nonatomic) id<KNTACalendarUpdateMomentDlegate> delegate;

@end
