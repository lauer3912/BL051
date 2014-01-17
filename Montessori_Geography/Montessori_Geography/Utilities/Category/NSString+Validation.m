//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.


#import "NSString+Validation.h"


@implementation NSString (OAURLEncodingAdditions)

- (NSString *)encodedURLString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,
                                                                                             NULL,                   // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                                           CFSTR("?=&+"),          // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                                           kCFStringEncodingUTF8)); // encoding
	return result ;
}

- (NSString *)encodedURLParameterString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR(":/=,!$&'()*+;[]@#?"),kCFStringEncodingUTF8));
	return result;
}

- (NSString *)decodedURLString
{
	NSString *result = (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
	return result;
}

-(NSString *)removeQuotes
{
	NSUInteger length = [self length];
	NSString *ret = self;
	if ([self characterAtIndex:0] == '"') {
		ret = [ret substringFromIndex:1];
	}
	if ([self characterAtIndex:length - 1] == '"') {
		ret = [ret substringToIndex:length - 2];
	}
	
	return ret;
}
#pragma mark - Not Null String
-(NSString *)RemoveNull
{
    if(self == nil)
    {
        return @"";
    }
    else if(self == (id)[NSNull null] || [self caseInsensitiveCompare:@"(null)"] == NSOrderedSame || [self caseInsensitiveCompare:@"<null>"] == NSOrderedSame || [self caseInsensitiveCompare:@""] == NSOrderedSame || [self length]==0)
    {
        return @"";
    }
    else
    {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


#pragma mark - Validate Email
-(BOOL)StringIsValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - Validate for Integer Number string
-(BOOL)StringIsIntigerNumber
{
    NSRegularExpression *regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"[0-9]" options:0 error:NULL];
    NSUInteger matches = [regex numberOfMatchesInString:self options:0
                                                  range:NSMakeRange(0, [self length])];
    if (matches == [self length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Validate for Float Number string
-(BOOL)StringIsFloatNumber
{
    if([self rangeOfString:@"."].location == NSNotFound)
    {
        return NO;
    }
    else
    {
        
        NSString *regx = @"(-){0,1}(([0-9]+)(.)){0,1}([0-9]+)";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
        return [test evaluateWithObject:self];
    }
}


#pragma mark - Complete Number string
-(BOOL)StringIsComplteNumber
{
    NSString *regx = @"(-){0,1}(([0-9]+)(.)){0,1}([0-9]+)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    return [test evaluateWithObject:self];
}


#pragma mark - alpha numeric string
-(BOOL)StringIsAlphaNumeric
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - illegal char in string
-(BOOL)StringWithIlligalChar
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -Strong Password
-(BOOL)StringWithStrongPassword:(int)minimumLength
{
    if([self length] <minimumLength)
    {
        return NO;
    }
    BOOL isCaps = FALSE;
    BOOL isNum = FALSE;
    BOOL isSymbol = FALSE;
    
    NSRegularExpression *regexCaps = [[NSRegularExpression alloc]
                                      initWithPattern:@"[A-Z]" options:0 error:NULL];
    NSUInteger intMatchesCaps = [regexCaps numberOfMatchesInString:self options:0
                                                             range:NSMakeRange(0, [self length])];
    if (intMatchesCaps > 0)
    {
        isCaps = TRUE;
    }
    
    NSRegularExpression *regexNum = [[NSRegularExpression alloc]
                                     initWithPattern:@"[0-9]" options:0 error:NULL];
    NSUInteger intMatchesNum = [regexNum numberOfMatchesInString:self options:0
                                                           range:NSMakeRange(0, [self length])];
    if (intMatchesNum > 0)
    {
        isNum = TRUE;
    }
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        isSymbol = TRUE;
    }
    
    if(isCaps == TRUE && isNum == TRUE && isSymbol == TRUE)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

-(float)getHeight_withFont:(UIFont *)myFont widht:(float)myWidth
{
    //CGSize textSize= [self sizeWithFont:myFont constrainedToSize:CGSizeMake(myWidth,CGFLOAT_MAX)lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         myFont, NSFontAttributeName,
                                         nil];
    
    CGRect frame = [self boundingRectWithSize:CGSizeMake(myWidth,CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributesDictionary
                                            context:nil];
    
    CGSize textSize = frame.size;
    return textSize.height;
}
-(NSString *)FormateDate_withCurrentFormate:(NSString *)currentFormate newFormate:(NSString *)dateFormatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:currentFormate];
    NSDate *date = [df dateFromString:self];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:dateFormatter];
    return [df stringFromDate:date];
}

-(NSDate *)getDate_withCurrentDateFormate:(NSString *)strFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:strFormat];
    NSDate *date = [df dateFromString:self];
    return date;
}



@end
