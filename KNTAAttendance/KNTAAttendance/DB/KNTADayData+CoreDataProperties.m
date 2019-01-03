//
//  KNTADayData+CoreDataProperties.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/14.
//  Copyright © 2018年 Kevin. All rights reserved.
//
//

#import "KNTADayData+CoreDataProperties.h"

@implementation KNTADayData (CoreDataProperties)

+ (NSFetchRequest<KNTADayData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"KNTADayData"];
}

@dynamic overTime;
@dynamic upMoment;
@dynamic offMonment;
@dynamic year;
@dynamic month;
@dynamic day;
@dynamic isInclude;
@dynamic season;

@end
