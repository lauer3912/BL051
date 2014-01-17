//
//  GlobalMethods.m
//  Montessori_Geography
//
//  Created by MAC236 on 10/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "GlobalMethods.h"
#import "SubclassInAppHelper.h"
#import "AppConstant.h"
#import "GlobalMethods.h"

@implementation GlobalMethods

#pragma mark - In App Products Verify
#pragma mark - In App Purchase

+(void)getProducts:(NSString*)strProductId
{
    [[SubclassInAppHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            [AppDel dismissGlobalHUD];
            ArryProducts = [[NSMutableArray alloc]initWithArray:products];
            
            [self BuyProduct:strProductId];
        }
        else
        {
            [AppDel dismissGlobalHUD];
            DisplayAlertWithTitle(@"Error Message", [products objectAtIndex:0]);
        }
    }];
}
+(void)RestoreInApp
{
    [AppDel showGlobalProgressHUDWithTitle:@"Restoring product...."];
    [SubclassInAppHelper sharedInstance];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
+(void)BuyProduct:(NSString*)strProductId
{
    if (ArryProducts.count == 0)
    {
        [AppDel showGlobalProgressHUDWithTitle:@"Loading products..."];
        [self getProducts:strProductId];
    }
    else
    {
        [AppDel showGlobalProgressHUDWithTitle:@"Buying products..."];
        SKProduct *product;
        for (product in ArryProducts)
        {
            if ([product.productIdentifier isEqualToString:strProductId])
            {
                break;
            }
        }
        [[SubclassInAppHelper sharedInstance] buyProduct: product];
    }
}


+(NSArray*)ReturnCurrentStageArray:(int)_CurrentStage ForKey:(NSString*)GroupOrCountry
{
    // We need to extract the properties of the stage from the plist file.
    NSString* plistsource = [[NSBundle mainBundle] pathForResource:@"MGAMapStages" ofType:@"plist"];
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistsource];
    
    // Now that we have a temporary Dictionary of all data, we
    // get the All stages Array we are interested in and setup the properties.
    NSArray *_stageDataArray = [temp objectForKey:@"stages"];
    
    if ([GroupOrCountry isEqualToString:@"AllStage"])
        return _stageDataArray;
    
    //get Current Stage Data
    NSDictionary *_CurrentStageDic = [_stageDataArray objectAtIndex:_CurrentStage];
    
    //Get Curretn Stage Group
    NSArray *_CurrentStageGroupArray = [_CurrentStageDic objectForKey:@"group"];
    
    return _CurrentStageGroupArray;
    
}
+(int)ReturnCurrentSatgeGroupForKey:(NSString*)forKey
{
    NSString *strCurrentStatus = [[NSUserDefaults retrieveObjectForKey:forKey] RemoveNull];
    
    //Set Curretn Stage & Group & Game Mode If It's First Time
    //Total Stage = 5 || Current Stage 0 = 1, 1=2, 2=3, 3=4, 4=5 || Array Start From 0 - Current Stage 0
    // Same as in Group
    int _CurrentValue = 0;
    
    if (strCurrentStatus.length == 0)
    {
        strCurrentStatus = [NSString stringWithFormat:@"%d",_CurrentValue];
        [NSUserDefaults saveObject:strCurrentStatus forKey:forKey];
    }
    else
        _CurrentValue = [strCurrentStatus intValue];
    
    return _CurrentValue;
}
+(NSDictionary*)ReturnPathForPlaneAnimationForStage:(int)StageValue ForGroup:(int)GroupValue
{
    // We need to extract the properties of the Plane Path from the plist file.
    //Plane Move
    NSString* plistsource = [[NSBundle mainBundle] pathForResource:@"MGAPlanePath" ofType:@"plist"];
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistsource];
    // get the path Detail we are interested in.
    
    NSArray *ArrayStages = [temp valueForKey:@"stages"];
    NSArray *ArryCurrentStageGroup = [[ArrayStages objectAtIndex:StageValue] valueForKey:@"groups"];
    NSDictionary *DicPathCurretnGroup = [ArryCurrentStageGroup objectAtIndex:GroupValue];
    
    return DicPathCurretnGroup;
}
@end