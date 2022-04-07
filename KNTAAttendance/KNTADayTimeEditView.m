//
//  KNTADayTimeEditView.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/16.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTADayTimeEditView.h"

@interface KNTADayTimeEditView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickView;

@property (strong, nonatomic) NSMutableArray *yearArray;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (assign, nonatomic) NSInteger dayCount;

@property (strong, nonatomic) NSCalendar *greCalendar;

@end

@implementation KNTADayTimeEditView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureData];
    
}

- (void)configureData
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.yearArray = [[NSMutableArray alloc] init];
    self.greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.dayCount = 31;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self.dateFormatter setDateFormat:@"yyyy"];
    NSInteger year = [[self.dateFormatter stringFromDate:date] integerValue];
    [self.yearArray addObject:[NSString stringWithFormat:@"%ld年", year - 1]];
    [self.yearArray addObject:[NSString stringWithFormat:@"%ld年", year]];
    [self.yearArray addObject:[NSString stringWithFormat:@"%ld年", year + 1]];
    
    [self.dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[self.dateFormatter stringFromDate:date] integerValue];
    
    [self.dateFormatter setDateFormat:@"dd"];
    NSInteger day = [[self.dateFormatter stringFromDate:date] integerValue];
    
    _dayCount = [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    [self.pickView selectRow:1 inComponent:1 animated:NO];
    [self.pickView selectRow:month - 1 inComponent:2 animated:NO];
    [self.pickView selectRow:day - 1 inComponent:3 animated:NO];
    
    [self.pickView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            return 2;
            break;
        }
        case 1:{
            return 3;
            break;
        }
        case 2:{
            return 12;
            break;
        }
        case 3:{
            return _dayCount;
            break;
        }
        case 4:{
            return 24;
            break;
        }
        case 5:{
            return 60;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            if (row == 0) {
                return @"上班";
            }
            return @"下班";
            break;
        }
        case 1:{
            
            return _yearArray[row];
            
            break;
        }
        case 2:{

            return [NSString stringWithFormat:@"%ld月", row + 1];
            
            break;
        }
        case 3:{
            
            return [NSString stringWithFormat:@"%ld日", row + 1];

            break;
        }
        case 4:{
            return [NSString stringWithFormat:@"%ld", row];
            break;
        }
        case 5:{
            return [NSString stringWithFormat:@"%ld", row];
            break;
        }
        default:
            break;
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    if (component == 0) {
        label.textColor = [UIColor redColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component != 0 && component != 3 && component != 4 && component != 5) {
        NSString *dateString = [NSString stringWithFormat:@"%@-0%ld", [_yearArray objectAtIndex:[pickerView selectedRowInComponent:1]], [pickerView selectedRowInComponent:2] + 1];
        [self.dateFormatter setDateFormat:@"yyyy年-MM"];
        NSDate *date = [self.dateFormatter dateFromString:dateString];
        _dayCount = [_greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
        [pickerView reloadComponent:3];
    }
}

- (IBAction)sureButtonClicked:(UIButton *)sender
{
    if (self.editHandle) {
        NSString *year = [_yearArray objectAtIndex:[_pickView selectedRowInComponent:1]];
        NSInteger month = [_pickView selectedRowInComponent:2] + 1;
        NSInteger day = [_pickView selectedRowInComponent:3] + 1;
        NSInteger hour = [_pickView selectedRowInComponent:4];
        NSInteger minute = [_pickView selectedRowInComponent:5];
        
        NSString *dateString = [NSString stringWithFormat:@"%@-%ld-%ld %ld:%ld", year, month, day, hour, minute];
        self.dateFormatter.dateFormat = @"yyyy年-MM-dd HH:mm";
        NSDate *date = [self.dateFormatter dateFromString:dateString];
        
        E_INSERTTYPE type = eTypeOff;
        if ([_pickView selectedRowInComponent:0] == 0) {
            type = eTypeUp;
        }
        self.editHandle(type, date);
    }
}


- (IBAction)clearData:(UIButton *)sender
{
    if (self.clearHandle) {
        NSString *year = [_yearArray objectAtIndex:[_pickView selectedRowInComponent:1]];
        NSInteger month = [_pickView selectedRowInComponent:2] + 1;
        NSInteger day = [_pickView selectedRowInComponent:3] + 1;
        
        NSString *dateString = [NSString stringWithFormat:@"%@-%ld-%ld", year, month, day];
        self.dateFormatter.dateFormat = @"yyyy年-MM-dd";
        NSDate *date = [self.dateFormatter dateFromString:dateString];
        
        self.clearHandle(date);
    }
}



@end
