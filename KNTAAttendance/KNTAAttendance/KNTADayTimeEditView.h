//
//  KNTADayTimeEditView.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/16.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNTARecordManager.h"

@interface KNTADayTimeEditView : UIView

@property (strong, nonatomic) NSDate *date;

@property (copy, nonatomic) void(^editHandle)(E_INSERTTYPE type, NSDate *date);

@end
