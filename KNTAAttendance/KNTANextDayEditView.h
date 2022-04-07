//
//  KNTANextDayEditView.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/20.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNTANextDayEditView : UIView


@property (strong, nonatomic) NSDate *editDate;


@property (copy, nonatomic) void(^sureHandle)(BOOL isWorkday);


@end

NS_ASSUME_NONNULL_END
