//
//  AppDelegate.m
//  Montessori_Geography
//
//  Created by Chirag on 30/12/13.
//  Copyright (c) 2013 MAC 227. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroductionViewCtr.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Hide Status Bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSLog(@"localeCountryCode: %@", countryCode);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    IntroductionViewCtr *obj_SplashViewCtr = [[IntroductionViewCtr alloc] initWithNibName:@"IntroductionViewCtr" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:obj_SplashViewCtr];
    
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Global Indicator Methods

- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = title;
    return hud;
}
- (void)dismissGlobalHUD
{
    //NSLog(@"Dismiss indicator Called");
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

- (BOOL) checkConnection
{
	const char *host_name = "www.google.com";
    BOOL _isDataSourceAvailable = NO;
    Boolean success;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,host_name);
	SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success &&
	(flags & kSCNetworkFlagsReachable) &&
	!(flags & kSCNetworkFlagsConnectionRequired);
	
    CFRelease(reachability);
	
    return _isDataSourceAvailable;
}
@end
