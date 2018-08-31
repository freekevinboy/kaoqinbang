//
//  KNTADBManager.m
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import "KNTADBManager.h"
#import "KNTADayData+CoreDataProperties.h"
#import "AppDelegate.h"

@interface KNTADBManager ()


@end

static KNTADBManager *manager = nil;

@implementation KNTADBManager

+ (BOOL)insertData:(NSString *)entityName handle:(id(^)(id obj))handle
{
    __block NSManagedObjectContext *context = nil;
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
        });
    } else {
         context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
    }
    KNTADayData *dayData = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    
    if (handle) {
        handle(dayData);
        NSError *error = nil;
        if ([context save:&error]) {
            return true;
        }
    }
    
    return NO;
}

+ (id)objFromDB:(NSString *)entityName limit:(NSUInteger)limit predicate:(NSString *)format,...
{
    __block NSManagedObjectContext *context = nil;
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
        });
    } else {
        context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
    }
    
    format = [format stringByReplacingOccurrencesOfString:@"&&" withString:@"and"];
    format = [format stringByReplacingOccurrencesOfString:@"||" withString:@"or"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    request.predicate = predicate;
    request.fetchLimit = limit;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    return arr;
}

+ (BOOL)updateData:(NSString *)entityName limit:(NSUInteger)limit handle:(void(^)(NSArray *array))handle predicate:(NSString *)format,...
{
    __block NSManagedObjectContext *context = nil;
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
        });
    } else {
        context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
    }
    
    NSArray *array = [self objFromDB:entityName limit:limit predicate:format];
    if (handle) {
        handle(array);
        NSError *error = nil;
        if ([context save:&error]) {
            return YES;
        }
    }
    return NO;
}

@end
