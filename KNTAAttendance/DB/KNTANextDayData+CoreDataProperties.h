//
//  KNTANextDayData+CoreDataProperties.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/12/21.
//  Copyright © 2018 Kevin. All rights reserved.
//
//

#import "KNTANextDayData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KNTANextDayData (CoreDataProperties)

+ (NSFetchRequest<KNTANextDayData *> *)fetchRequest;

@property (nonatomic) BOOL isRestday;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *day;

@end

NS_ASSUME_NONNULL_END
