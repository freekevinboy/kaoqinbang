//
//  KNTANextDayEditView.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/20.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import "KNTANextDayEditView.h"
#import "KNTANextManager.h"
#import "KNTANextDayData+CoreDataProperties.h"


@interface KNTANextDayEditView ()

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UISwitch *isWorkdaySitch;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


@end



@implementation KNTANextDayEditView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureData];
    
}

- (void)configureData
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
}

- (void)setEditDate:(NSDate *)editDate
{
    _editDate = editDate;
    
    self.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [self.dateFormatter stringFromDate:editDate];
    self.dateFormatter.dateFormat = @"MM";
    NSString *month = [self.dateFormatter stringFromDate:editDate];
    self.dateFormatter.dateFormat = @"dd";
    NSString *day = [self.dateFormatter stringFromDate:editDate];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    self.dateLabel.text = dateStr;
    
    KNTANextDayData *data = [KNTANextManager objectByPredicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day].firstObject;
    if (data.isRestday) {
        self.isWorkdaySitch.on = NO;
    } else {
        self.isWorkdaySitch.on = YES;
    }
}

- (IBAction)sureButtonClicked:(UIButton *)sender
{
    if (self.sureHandle) {
        self.sureHandle(_isWorkdaySitch.isOn);
    }
}


@end
