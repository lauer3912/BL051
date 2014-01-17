//
//  IntroductionViewCtr.h
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helpers)

/* convenience method to save a given object for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key;

/* convenience method to return an object for a given key */
+ (id)retrieveObjectForKey:(NSString *)key;

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key;

@end
