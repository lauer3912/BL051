//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import "NSUserDefaults+Helpers.h"

@implementation NSUserDefaults (Helpers)

/* convenience method to save a given string for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

/* convenience method to return a string for a given key */
+ (id)retrieveObjectForKey:(NSString *)key
{
    return [[self standardUserDefaults] objectForKey:key];
}

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end
