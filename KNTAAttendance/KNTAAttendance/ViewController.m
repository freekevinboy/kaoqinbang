//
//  ViewController.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "KNTACalendarController.h"
#import "KNTARecordManager.h"
#import "KNTASettingViewController.h"
#import "KNTABasicSetting.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()<KNTACalendarUpdateMomentDlegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)upClicked:(UIButton *)sender
{
    [self updateUpmoment:[NSDate date]];
}

- (IBAction)offClicked:(UIButton *)sender
{
    [self updateOffMoment:[NSDate date]];
}

- (void)updateUpmoment:(NSDate *)date
{
    [KNTARecordManager updateDataType:eTypeUp
                                 date:date
                               handle:nil
                         updateHandle:nil
                            predicate:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)updateOffMoment:(NSDate *)date
{
    [KNTARecordManager updateDataType:eTypeOff
                                 date:date
                               handle:^E_DEALOFFTYPE{
                                   
                                   __block E_DEALOFFTYPE type = eTypeCurrentDay;
                                   
                                   if ([KNTABasicSetting sharedInstance].promptWithoutUptime == YES) {
                                       dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"当天没有上班数据" preferredStyle:UIAlertControllerStyleAlert];
                                           [ctrl addAction:[UIAlertAction actionWithTitle:@"同步到最近有上班数据的一天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                               type = eTypeLastUp;
                                               dispatch_semaphore_signal(semaphore);
                                               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                           }]];
                                           [ctrl addAction:[UIAlertAction actionWithTitle:@"就是没有上班数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                               type = eTypeCurrentDay;
                                               dispatch_semaphore_signal(semaphore);
                                               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                           }]];
                                           
                                           [self presentViewController:ctrl animated:NO completion:nil];
                                           
                                       });
                                       
                                       dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                                   }
                                   
                                   return type;
                               }
                         updateHandle:nil
                            predicate:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (void)updateMoment:(NSDate *)date type:(E_INSERTTYPE)eType
{
    switch (eType) {
        case eTypeUp:{
            [self updateUpmoment:date];
            break;
        }
        case eTypeOff:{
            [self updateOffMoment:date];
            break;
        }
        default:
            break;
    }
}


- (IBAction)detailClicked:(UIButton *)sender
{
    KNTACalendarController *ctrl = [[KNTACalendarController alloc] init];
    
    ctrl.delegate = self;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)settingButtonClicked:(UIBarButtonItem *)sender
{
    KNTASettingViewController *ctrl = [[UIStoryboard storyboardWithName:@"KNTASettingViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"KNTASettingViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
