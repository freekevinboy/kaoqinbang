//
//  KNTACalendarController.m
//  TestReactiveCocoa
//
//  Created by Kevin on 2018/7/11.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTACalendarController.h"
#import "KNTACalendarManager.h"
#import "KNTAMonthModel.h"
#import "KNTARecordManager.h"
#import "KNTADayTimeEditView.h"
#import "KNTADayData+CoreDataClass.h"
#import "KNTABasicSetting.h"

#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kOffsetY (KISIphoneX ? 88 : 64)
#define kHeaderHeight 54
#define kItemHeight 75

#define kNilToEmpty(str) (str ? : @"")
#define kEmptyString(param, str) str.length ? [NSString stringWithFormat:@"%@%@", param, str] : @""

#define kWeekArray @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]

@interface KNTACalendarController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation KNTACalendarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureUI];
    [self configureData];
}

- (void)configureData
{
    if (!self.indicatorView) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.frame = CGRectMake((kScreenSize.width - 50.0)/2.0, (kScreenSize.height - 50.0)/2.0 - 64, 50, 50);
        [self.view addSubview:_indicatorView];
    }
    [self.indicatorView startAnimating];
    self.view.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        KNTACalendarManager *manager = [[KNTACalendarManager alloc] init];
        manager.startDate = kStartTime;
        self.dataArray = manager.calendarData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.view.userInteractionEnabled = YES;
            [self.collectionView reloadData];
            if (self.dataArray.count) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:((KNTAMonthModel *)self.dataArray.lastObject).calendarArray.count - 1 inSection:self.dataArray.count - 1] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
        });
    });
}

- (void)configureUI
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kOffsetY, kScreenSize.width, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:177.0/255.0 blue:44.0/255.0 alpha:0.8];
    [self.view addSubview:headerView];
    
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * (kScreenSize.width/7.0), 0, (kScreenSize.width/7.0), 35)];
        label.textColor = (i != 0 && i != 6) ? [UIColor whiteColor] : [UIColor redColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.text = kWeekArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenSize.width/7.0, kItemHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.headerReferenceSize = CGSizeMake(kScreenSize.width, kHeaderHeight);
    layout.footerReferenceSize = CGSizeMake(kScreenSize.width, 15);
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kOffsetY + 35, kScreenSize.width, kScreenSize.height - kOffsetY - 35) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    KNTAMonthModel *model = _dataArray[section];
    return model.calendarArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editAttendenceData:)];
    longpress.minimumPressDuration = 0.8;
    [cell.contentView addGestureRecognizer:longpress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarCellDidDoublicked:)];
    tap.numberOfTapsRequired = 4;
    [cell.contentView addGestureRecognizer:tap];
    
    KNTAMonthModel *monthModel = _dataArray[indexPath.section];
    KNTACalendarModel *model = monthModel.calendarArray[indexPath.row];
    NSString *subTitle = model.holiday ? model.holiday : model.chineseDay;
    NSString *isInclude = model.isInclude ? @"" : ((model.upMoment.length || model.offMoment.length) ? @"N/A" : @"");
    
    UILabel *label = [cell.contentView viewWithTag:1001];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width / 7.0, kItemHeight)];
        label.numberOfLines = 0;
        label.tag = 1001;
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:9.0];
        [cell.contentView addSubview:label];
    }
    NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@", kNilToEmpty(model.day), kNilToEmpty(subTitle), isInclude, kNilToEmpty(model.upMoment), kNilToEmpty(model.offMoment), kNilToEmpty(model.overTime)];
    NSRange titleRange = [text rangeOfString:kNilToEmpty(model.day)];
    NSRange subTitleRange = [text rangeOfString:kNilToEmpty(subTitle)];
    NSRange upTimeRange = [text rangeOfString:kNilToEmpty(model.upMoment)];
    NSRange offTimeRange = [text rangeOfString:kNilToEmpty(model.offMoment)];
    NSRange overTimeRange = [text rangeOfString:kNilToEmpty(model.overTime)];

    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} range:titleRange];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0]} range:subTitleRange];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0]} range:upTimeRange];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0]} range:offTimeRange];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0]} range:offTimeRange];
    [attText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0]} range:overTimeRange];
    
    if (model.isInclude && [self isOverStandard:[KNTABasicSetting sharedInstance].dayRedOffMoment date:model.offMoment overTime:model.overTime]) {
        [attText addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:offTimeRange];
    }
    
    label.attributedText = attText;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    UILabel *label = [headerView viewWithTag:1001];
    if (!label) {
        headerView.layer.masksToBounds = NO;
        headerView.layer.shadowRadius = 25.0;
        headerView.layer.shadowOpacity = 0.8;
        headerView.layer.shadowColor = [UIColor whiteColor].CGColor;
        headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:headerView.bounds].CGPath;
        headerView.backgroundColor = [UIColor whiteColor];
        
        CGMutablePathRef linePath = CGPathCreateMutable();
        CGPathMoveToPoint(linePath, NULL, 0, 0);
        CGPathAddLineToPoint(linePath, NULL, kScreenSize.width, 0);
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = linePath;
        CGPathRelease(linePath);
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        layer.lineWidth = 0.3;
        layer.opacity = 0.5;
        [headerView.layer addSublayer:layer];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenSize.width - 20, kHeaderHeight - 10)];
        label.tag = 1001;
        label.numberOfLines = 0;
        [label setAdjustsFontSizeToFitWidth:YES];
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
        
    }
    KNTAMonthModel *model = _dataArray[indexPath.section];
    
    NSString *yearMoment = kEmptyString(@": ", model.yearOffMoment);
    NSString *seasonMoment = kEmptyString(@": ", model.seasonOffMoment);
    NSString *monthMoment = kEmptyString(@": ", model.monthOffMoment);

    NSString *text = [NSString stringWithFormat:@"%@年%@\n%@季度%@\n%@月%@", model.year, yearMoment, model.season, seasonMoment, model.month, monthMoment];
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    
    if ([self isOverStandard:[KNTABasicSetting sharedInstance].monthRedOffMoment date:model.monthOffMoment overTime:nil]) {
        [attText addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:[text rangeOfString:model.monthOffMoment ? : @"" options:NSBackwardsSearch]];
    }
    
    label.attributedText = attText;
    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)editAttendenceData:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGRect frame = [sender.view convertRect:sender.view.frame toView:self.collectionView];
        CGPoint fuzzyPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame)/2, CGRectGetMinY(frame));
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:fuzzyPoint];
        KNTAMonthModel *monthModel = _dataArray[indexPath.section];
        KNTACalendarModel *model = monthModel.calendarArray[indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@", model.year, model.month, model.day]];
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor lightGrayColor];
        view.alpha = 0;
        view.userInteractionEnabled = YES;
        view.tag = 1090;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapped:)];
        [view addGestureRecognizer:tap];
        
        KNTADayTimeEditView *editView = [[NSBundle mainBundle] loadNibNamed:@"KNTADayTimeEditView" owner:view options:nil].lastObject;
        editView.frame = CGRectMake(0, kScreenSize.height + 150, kScreenSize.width, 150);
        editView.date = date;
        editView.editHandle = ^(E_INSERTTYPE type, NSDate *date) {
            [KNTARecordManager updateDataType:type
                                         date:date
                                       handle:nil
                                 updateHandle:nil
                                    predicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", model.year, model.month, model.day];
            
            [self shadowViewTapped:nil];
            [self configureData];
        };
        [self.view addSubview:editView];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0.6;
            editView.frame = CGRectMake(0, kScreenSize.height - 150, kScreenSize.width, 150);
        }];
    }
    
}


- (void)calendarCellDidDoublicked:(UITapGestureRecognizer *)sender
{
    if (![KNTABasicSetting sharedInstance].doubleClickForEdit) {
        return;
    }
    
    CGRect frame = [sender.view convertRect:sender.view.frame toView:self.collectionView];
    CGPoint fuzzyPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame)/2, CGRectGetMinY(frame));
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:fuzzyPoint];
    KNTAMonthModel *monthModel = _dataArray[indexPath.section];
    KNTACalendarModel *model = monthModel.calendarArray[indexPath.row];
    [KNTARecordManager updateDataType:0
                                 date:[NSDate date]
                               handle:nil
                         updateHandle:^(id obj) {
                             ((KNTADayData *)obj).isInclude = !((KNTADayData *)obj).isInclude;
                             [self configureData];
                         }
                            predicate:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", model.year, model.month, model.day];
}


- (void)shadowViewTapped:(UITapGestureRecognizer *)sender
{
    for (KNTADayTimeEditView *view in self.view.subviews) {
        if ([view isKindOfClass:[KNTADayTimeEditView class]]) {
            [UIView animateWithDuration:0.25 animations:^{
                view.frame = CGRectMake(0, kScreenSize.height + 150, kScreenSize.width, 150);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                UIView *sendView = [self.view viewWithTag:1090];
                [sendView removeFromSuperview];
                [view removeFromSuperview];
            }];
            
            break;
        }
    }
}

- (BOOL)isOverStandard:(NSString *)standardD date:(NSString *)d overTime:(NSString *)overTime
{
    BOOL isOver = NO;
    
    if (!d.length || !standardD.length) {
        return isOver;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    
    NSDate *stadardDate = [format dateFromString:standardD];
    NSDate *date = [format dateFromString:d];
    
    if ([date compare:stadardDate] == NSOrderedAscending && !overTime) {
        isOver = YES;
    };
    
    return isOver;
}

- (void)dealloc
{
    
}


@end
