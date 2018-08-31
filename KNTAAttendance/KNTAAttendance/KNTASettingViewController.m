//
//  KNTASettingViewController.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/25.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTASettingViewController.h"
#import "KNTAPubDefine.h"
#import "KNTABasicSetting.h"

@interface KNTASettingViewController ()

@property (strong, nonatomic) IBOutlet UITextField *dayRedHourTextF;
@property (strong, nonatomic) IBOutlet UITextField *dayRedMinuteTextF;
@property (strong, nonatomic) IBOutlet UITextField *dayStandardHourTextF;
@property (strong, nonatomic) IBOutlet UITextField *dayStandardMinuteTextF;

@property (strong, nonatomic) IBOutlet UITextField *monthRedHourTextF;
@property (strong, nonatomic) IBOutlet UITextField *monthRedMinuteTextF;

@property (strong, nonatomic) IBOutlet UISwitch *includeSwitch;

@end

@implementation KNTASettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    NSString *dayRed = K_OFFMOMENT_RED_DAY_STORAGE;
    self.dayRedHourTextF.text = [dayRed componentsSeparatedByString:@":"].firstObject;
    self.dayRedMinuteTextF.text = [dayRed componentsSeparatedByString:@":"].lastObject;
    
    NSString *monthRed = K_OFFMOMENT_RED_MONTH_STORAGE;
    self.monthRedHourTextF.text = [monthRed componentsSeparatedByString:@":"].firstObject;
    self.monthRedMinuteTextF.text = [monthRed componentsSeparatedByString:@":"].lastObject;
    
    NSString *dayStandard = K_OFFMOMENT_STANDARD_STORAGE;
    self.dayStandardHourTextF.text = [dayStandard componentsSeparatedByString:@":"].firstObject;
    self.dayStandardMinuteTextF.text = [dayStandard componentsSeparatedByString:@":"].lastObject;
    
    NSNumber *include = K_MOMENTJOINACCOCULATE_STORAGE;
    self.includeSwitch.on = include.boolValue;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (IBAction)SureButtonClicked:(UIButton *)sender
{
    if ([_dayRedHourTextF.text integerValue] > 0 && [_dayRedHourTextF.text integerValue] < 24 &&
        [_dayRedMinuteTextF.text integerValue] >= 0 && [_dayRedMinuteTextF.text integerValue] <= 59)
    {
        NSString *str = [NSString stringWithFormat:@"%@:%@", _dayRedHourTextF.text, _dayRedMinuteTextF.text];
        K_SET_OFFMOMENT_RED_DAY_STORAGE(str);
        [KNTABasicSetting sharedInstance].dayRedOffMoment = str;
    }
    
    if ([_monthRedHourTextF.text integerValue] > 0 && [_monthRedHourTextF.text integerValue] < 24 &&
        [_monthRedMinuteTextF.text integerValue] >= 0 && [_monthRedMinuteTextF.text integerValue] <= 59)
    {
        NSString *str = [NSString stringWithFormat:@"%@:%@", _monthRedHourTextF.text, _monthRedMinuteTextF.text];
        K_SET_OFFMOMENT_RED_MONTH_STORAGE(str);
        [KNTABasicSetting sharedInstance].monthRedOffMoment = str;
    }
    if ([_dayStandardHourTextF.text integerValue] > 0 && [_dayStandardHourTextF.text integerValue] < 24 &&
        [_dayStandardMinuteTextF.text integerValue] >= 0 && [_dayStandardMinuteTextF.text integerValue] <= 59)
    {
        NSString *str = [NSString stringWithFormat:@"%@:%@", _dayStandardHourTextF.text, _dayStandardMinuteTextF.text];
        K_SET_OFFMOMENT_STANDARD_STORAGE(str);
        [KNTABasicSetting sharedInstance].dayStandardOvertimeStartMoment = str;
    }
    NSNumber *boolObj = [NSNumber numberWithBool:_includeSwitch.isOn];
    K_SET_MOMENTJOINACCOCULATE_STORAGE(boolObj);
    [KNTABasicSetting sharedInstance].doubleClickForEdit = _includeSwitch.isOn;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
