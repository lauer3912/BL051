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
            DisplayAlertWithTitle(LSSTRING(@"Error Message"), [products objectAtIndex:0]);
        }
    }];
}
+(void)RestoreInApp
{
    [AppDel showGlobalProgressHUDWithTitle:@"Restoring purchases...."];
    [[SubclassInAppHelper sharedInstance] restoreCompletedTransactions];
}
+(void)BuyProduct:(NSString*)strProductId
{
    if (ArryProducts.count == 0)
    {
        [AppDel showGlobalProgressHUDWithTitle:LSSTRING(@"Loading products...")];
        [self getProducts:strProductId];
    }
    else
    {
        [AppDel showGlobalProgressHUDWithTitle:LSSTRING(@"Buying products...")];
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
    
    if (GroupValue == 111)
        GroupValue = [ArryCurrentStageGroup count] - 1;
    
    NSDictionary *DicPathCurretnGroup = [ArryCurrentStageGroup objectAtIndex:GroupValue];
    
    return DicPathCurretnGroup;
}
+(NSString*)ReturnStageTitle:(int)StageValue
{
    switch (StageValue) {
        case 0:
            return LSSTRING(@"East Asia");
            break;
        case 1:
            return LSSTRING(@"Southeast Asia");
            break;
        case 2:
            return LSSTRING(@"South Asia");
            break;
        case 3:
            return LSSTRING(@"Central Asia");
            break;
        case 4:
            return LSSTRING(@"Middle East");
            break;
        case 5:
            return LSSTRING(@"Eurasia");
            break;
        default:
            break;
    }
    return @"";
}
+(CGRect)ReturnFrameForAllGroup:(int)StageValue{
    CGRect MapFrame;
    
    if (StageValue == 1) {
        MapFrame = CGRectMake(18.05, 344.42, 581.55, 392.58);
        //18.05	344.42	581.55	392.58
    }
    else if (StageValue == 2) {
        MapFrame = CGRectMake(0.00, 0.00, 883.50, 426.50);
        //0.00	0.00	883.50	426.50
    }
    else if (StageValue == 3) {
        MapFrame = CGRectMake(0.00, 0.00, 1024.00, 768.00);
        //0.00	0.00	1024.00	768.00
    }
    else if (StageValue == 4) {
        MapFrame = CGRectMake(0.00, 0.00, 1024.00, 768.00);
        //0.00	0.00	1024.00	768.00
    }
    else if (StageValue == 5) {
        MapFrame = CGRectMake(434.00, 0.00, 590.00, 504.50);
        //434.00	0.00	590.00	504.50
    }
    return MapFrame;

}
+(void)replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view
{
    for (UIView* v in view.subviews)
    {
        if (v.subviews.count > 0)
        {
            [self replaceTextWithLocalizedTextInSubviewsForView:v];
        }
        
        if ([v isKindOfClass:[UILabel class]])
        {
            UILabel* l = (UILabel*)v;
            l.text = NSLocalizedString(l.text, nil);
        }
        
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton* b = (UIButton*)v;
            [b setTitle:NSLocalizedString(b.titleLabel.text, nil) forState:UIControlStateNormal];
        }
        
        if ([v isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl* s = (UISegmentedControl*)v;
            for (int i = 0; i < s.numberOfSegments; i++) {
                [s setTitle:NSLocalizedString([s titleForSegmentAtIndex:i],nil) forSegmentAtIndex:i];
            }
        }
        
        if ([v isKindOfClass:[UITextField class]])
        {
            UITextField* tf = (UITextField*)v;
            tf.placeholder = NSLocalizedString(tf.placeholder, nil);
        }
        
    }
}

@end
