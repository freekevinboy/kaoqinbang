//
//  KNTANextDayData+CoreDataProperties.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/21.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "KNTANextDayData+CoreDataProperties.h"

@implementation KNTANextDayData (CoreDataProperties)

+ (NSFetchRequest<KNTANextDayData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"KNTANextDayData"];
}

@dynamic isRestday;
@dynamic year;
@dynamic month;
@dynamic day;

@end
