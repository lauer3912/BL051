//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.


#import <Foundation/Foundation.h>


@interface NSString (OAURLEncodingAdditions)

- (NSString *)encodedURLString;
- (NSString *)encodedURLParameterString;
- (NSString *)decodedURLString;
- (NSString *)removeQuotes;

//Not Null String
-(NSString *)RemoveNull;

//Validate Email
-(BOOL)StringIsValidEmail;

//Validate for Integer Number string
-(BOOL)StringIsIntigerNumber;

//Validate for Float Number string
-(BOOL)StringIsFloatNumber;

//Complete Number string
-(BOOL)StringIsComplteNumber;

//alpha numeric string
-(BOOL)StringIsAlphaNumeric;

//illegal char in string
-(BOOL)StringWithIlligalChar;

//Strong Password
-(BOOL)StringWithStrongPassword:(int)minimumLength;

-(float)getHeight_withFont:(UIFont *)myFont widht:(float)myWidth;

//Formate Date
-(NSString *)FormateDate_withCurrentFormate:(NSString *)currentFormate newFormate:(NSString *)dateFormatter;


//Get Date
-(NSDate *)getDate_withCurrentDateFormate:(NSString *)strFormat;


@end
