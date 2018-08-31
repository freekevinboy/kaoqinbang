//
//  KNTAPubDefine.h
//  KNTAAttendance
//
//  Created by Kevin on 2018/7/26.
//  Copyright © 2018年 Kevin. All rights reserved.
//


#define kStartOverMoment @"19:00"


#define K_KEY_OFFMOMENT_RED_DAY @"K_KEY_OFFMOMENT_RED_DAY"

#define K_KEY_OFFMOMENT_RED_MONTH @"K_KEY_OFFMOMENT_RED_MONTH"

#define K_KEY_OFFMOMENT_STANDARD @"K_KEY_OFFMOMENT_STANDARD"

#define K_KEY_MOMENTJOINACCOCULATE @"K_KEY_MOMENTJOINACCOCULATE"

#define K_OFFMOMENT_RED_DAY_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_RED_DAY];
#define K_SET_OFFMOMENT_RED_DAY_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_RED_DAY];

#define K_OFFMOMENT_RED_MONTH_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_RED_MONTH];
#define K_SET_OFFMOMENT_RED_MONTH_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_RED_MONTH];

#define K_OFFMOMENT_STANDARD_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_OFFMOMENT_STANDARD];
#define K_SET_OFFMOMENT_STANDARD_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_OFFMOMENT_STANDARD];

#define K_MOMENTJOINACCOCULATE_STORAGE [[NSUserDefaults standardUserDefaults] objectForKey:K_KEY_MOMENTJOINACCOCULATE];
#define K_SET_MOMENTJOINACCOCULATE_STORAGE(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:K_KEY_MOMENTJOINACCOCULATE];

