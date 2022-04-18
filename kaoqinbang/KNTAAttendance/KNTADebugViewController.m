//
//  KNTADebugViewController.m
//  KNTAAttendance
//
//  Created by Kevin on 2022/4/7.
//  Copyright © 2022 Kevin. All rights reserved.
//

#import "KNTADebugViewController.h"
#import "KNTADBManager.h"
#import "KNTADayData+CoreDataClass.h"
#import "Masonry.h"


#define kScreenSize [UIScreen mainScreen].bounds.size


@interface KNTADebugViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;


@end

@implementation KNTADebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.frame = CGRectMake((kScreenSize.width - 50.0)/2.0, (kScreenSize.height - 50.0)/2.0 - 64, 50, 50);
        [self.view addSubview:_indicatorView];
    }
    [self.indicatorView startAnimating];
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSArray *arr = [KNTADBManager objFromDB:@"KNTADayData" limit:MAXBSIZE predicate:nil];
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (KNTADayData *data in arr) {
            [str appendFormat:@"%@年%@季度%@月%@日-上班时间: %@-下班时间: %@-是否纳入计算%d\n\n", data.year, data.season, data.month, data.day, data.upMoment, data.offMonment, data.isInclude];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.view.userInteractionEnabled = YES;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.numberOfLines = 0;
            label.text = str;
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            [scrollView addSubview:label];
            [self.view addSubview:scrollView];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(scrollView);
                make.width.equalTo(self.view);
            }];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];
        });
    });
}

@end
