//
//  AppConstant.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import "AppDelegate.h"
#import "MGAStageSteps.h"
#import "MGACurrentMode.h"
#import "NSMutableArray+Shuffling.h"
#import "NSUserDefaults+Helpers.h"
#import "NSString+Validation.h"
#import "GlobalMethods.h"

#ifndef Montessori_Geography_AppConstant_h
#define Montessori_Geography_AppConstant_h

#pragma mark - Alert

//MSG
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//alert with message and title
#define DisplayAlertWithTitle(title,msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }


//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }


//alert with Offline message
#define DisplayLocalizedAlertNoInternet {UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!",@"") message:NSLocalizedString(@"You're not connected to the internet.\nPlease connect and retry.",@"") delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil]; [alertView show]; }

#define Questrial_Regular(f) [UIFont fontWithName:@"Questrial-Regular" size:f]
#define KGPrimaryPenmanship2(f) [UIFont fontWithName:@"KGPrimaryPenmanship2" size:f]
#define P(x,y) CGPointMake(x, y)

#define kSizeDiff 3


#define PlaneAnimationTime 16.0
#define StepCompleteAnimationTime 5.0

// Set RGB Color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]


#define LSSTRING(str) NSLocalizedString(str, nil)

//Current Stage & Group & GameMode
#define CurrentStage_Map @"CurrentStage_Map"
#define CurrentGroup_Map @"CurrentGroup_Map"
#define CurrentStage_Flag @"CurrentStage_Flag"
#define CurrentGroup_Flag @"CurrentGroup_Flag"

#define CurrentGameMode @"CurrentGameMode"


#pragma mark - InAppPurchase

#define APP_ID @""

#define InApp_Countries_ID @"MGA_001"
#define InApp_Flags_ID @"MGA_002"
#define InApp_Countries_Flags_ID @"MGA_003"


#define SharedSecret @"67be95a0338f49e58f4718c68ff7a5f8"

#define IAPHelperProductPurchasedNotification  @"IAPHelperProductPurchasedNotification"
#define IAPHelperProductNotPurchasedNotification  @"IAPHelperProductNotPurchasedNotification"
NSMutableArray *ArryProducts;


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
