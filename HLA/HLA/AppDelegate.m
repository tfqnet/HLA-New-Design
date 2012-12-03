//
//  AppDelegate.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize indexNo;
@synthesize userRequest, MhiMessage;

@synthesize window = _window;

NSString * const NSURLIsExcludedFromBackupKey =@"NSURLIsExcludedFromBackupKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //for ios6 start, will also clear out ios5.1
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *viewerPlistFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"viewer.plist"];
    NSString *viewerPlistFromDoc = [documents stringByAppendingPathComponent:@"viewer.plist"];
    BOOL plistExist = [fileManager fileExistsAtPath:viewerPlistFromDoc];
    if (!plistExist)
        [fileManager copyItemAtPath:viewerPlistFromApp toPath:viewerPlistFromDoc error:nil];
    
    //databaseName = @"0000000000000001.sqlite";//actual
    NSString *databaseName1 = @"hladb.sqlite";//dummy
    NSString *WebSQLSubdir1 = @"Caches";
    NSString *WebSQLPath1 = [library stringByAppendingPathComponent:WebSQLSubdir1];
    NSString *WebSQLDb1 = [WebSQLPath1 stringByAppendingPathComponent:@"file__0"];
    
    
    NSString *masterFile = [WebSQLPath1 stringByAppendingPathComponent:@"Databases.db"];
    NSString *databaseFile = [WebSQLDb1 stringByAppendingPathComponent:databaseName1];
    
    [fileManager removeItemAtPath:databaseFile error:nil];
    [fileManager removeItemAtPath:masterFile error:nil];
    fileManager = Nil;
    //for ios6 end
    
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

@end
