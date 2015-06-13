//
//  AppDelegate.m
//  Snappa
//
//  Created by Sam Edson on 6/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#import "AppDelegate.h"

#import "GameViewController.h"

@interface AppDelegate ()
@property (nonatomic, weak) GameViewController* gameController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Use the following to send the log to the server in the background
    // http://stackoverflow.com/questions/5323634/ios-application-executing-tasks-in-background
    [self saveSnappaGame];
    
    
    if ([self.window.rootViewController isKindOfClass:[GameViewController class]]) {
        self.gameController = (GameViewController*)self.window.rootViewController;
    } else {
        self.gameController = nil;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self uploadSnappaGame];
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveSnappaGame];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)uploadSnappaGame {
    if (self.gameController) {
        [self.gameController syncWithServer];
    }
}

- (void)saveSnappaGame {
    if ([self.window.rootViewController isKindOfClass:[GameViewController class]]) {
        GameViewController* gameController = (GameViewController*)self.window.rootViewController;
        [gameController saveGame];
    }
}

@end
