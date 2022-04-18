//
//  KNTANextManager.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/21.
//  Copyright © 2018 Kevin. All rights reserved.
//

#import "KNTANextManager.h"
#import "KNTANextDayData+CoreDataProperties.h"
#import "AppDelegate.h"
#import "KNTADBManager.h"

@interface KNTANextManager ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


@end

static KNTANextManager *manager = nil;

@implementation KNTANextManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];

    }
    return self;
}


+ (KNTANextManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KNTANextManager alloc] init];
    });
    return manager;
}


+ (void)insertData:(BOOL)desValue date:(NSDate *)date
{
    KNTANextManager *manager = [KNTANextManager sharedInstance];
    manager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"MM";
    NSString *month = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"dd";
    NSString *day = [manager.dateFormatter stringFromDate:date];
    
    
    [KNTADBManager insertData:@"KNTANextDayData" handle:^id(KNTANextDayData *obj) {
        obj.year = year;
        obj.month = month;
        obj.day = day;
        obj.isRestday = desValue;
        
        return obj;
    }];
}

+ (void)updateData:(BOOL)desValue date:(NSDate *)date
{
    KNTANextManager *manager = [KNTANextManager sharedInstance];
    manager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"MM";
    NSString *month = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"dd";
    NSString *day = [manager.dateFormatter stringFromDate:date];
    
    NSString *format = [NSString stringWithFormat:@"year = \'%@\' && month = \'%@\' && day = \'%@\'", year, month, day];
    
    [KNTADBManager updateData:@"KNTANextDayData"
                        limit:MAXBSIZE
                       handle:^(NSArray *array) {
                           if (array.count) {
                               for (KNTANextDayData *data in array) {
                                   data.isRestday = desValue;
                               }
                           } else {
                               [KNTANextManager insertData:desValue date:date];
                           }
                       }
                    predicate:format];
}


+ (NSArray *)objectByPredicate:(NSString *)format,...
{
    va_list ap;
    va_start(ap, format);
    NSString *message = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    NSArray *res = [KNTADBManager objFromDB:@"KNTANextDayData" limit:31 predicate:message];
    return res;
}

+ (void)deleteDBData:(NSDate *)date
{
    KNTANextManager *manager = [KNTANextManager sharedInstance];
    manager.dateFormatter.dateFormat = @"yyyy";
    NSString *year = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"MM";
    NSString *month = [manager.dateFormatter stringFromDate:date];
    manager.dateFormatter.dateFormat = @"dd";
    NSString *day = [manager.dateFormatter stringFromDate:date];
    
    NSString *format = [NSString stringWithFormat:@"year <= \'%@\' || month <= \'%@\' || day <= \'%@\'", year, month, day];
    
    [KNTADBManager deleteData:@"KNTANextDayData" predicate:format];
}


@end
