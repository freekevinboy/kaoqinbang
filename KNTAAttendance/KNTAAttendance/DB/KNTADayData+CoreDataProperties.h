//
//  KNTADayData+CoreDataProperties.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/14.
//  Copyright © 2018年 Kevin. All rights reserved.
//
//

#import "KNTADayData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KNTADayData (CoreDataProperties)

+ (NSFetchRequest<KNTADayData *> *)fetchRequest;

@property (nonatomic) int64_t overTime;
@property (nullable, nonatomic, copy) NSString *upMoment;
@property (nullable, nonatomic, copy) NSString *offMonment;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *day;
@property (nonatomic) BOOL isInclude;
@property (nullable, nonatomic, copy) NSString *season;

@end

NS_ASSUME_NONNULL_END
