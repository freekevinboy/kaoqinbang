//
//  AppDelegate.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

