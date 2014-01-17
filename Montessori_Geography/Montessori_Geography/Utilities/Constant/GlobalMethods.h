//
//  GlobalMethods.h
//  Montessori_Geography
//
//  Created by MAC236 on 10/01/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject

//In App Purchases Products
+(void)getProducts:(NSString*)strProductId;
+(void)RestoreInApp;
+(void)BuyProduct:(NSString*)strProductId;

+(NSArray*)ReturnCurrentStageArray:(int)_CurrentStage ForKey:(NSString*)GroupOrCountry;

+(int)ReturnCurrentSatgeGroupForKey:(NSString*)forKey;

+(NSDictionary*)ReturnPathForPlaneAnimationForStage:(int)StageValue ForGroup:(int)GroupValue;
@end
