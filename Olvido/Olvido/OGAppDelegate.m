//
//  AppDelegate.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAppDelegate.h"
#import "OGGameViewController.h"
#import "OGPauseState.h"
#import "OGGameState.h"

NSString *const kOGAppDelegateMainStoryboardName = @"Main";

@interface OGAppDelegate ()

@property (nonatomic, retain) OGGameViewController *gameViewController;

@end

@implementation OGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kOGAppDelegateMainStoryboardName bundle:nil];
    
    self.gameViewController = [mainStoryboard instantiateInitialViewController];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [window release];
    
    self.window.rootViewController = self.gameViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.gameViewController pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)dealloc
{
    [_window release];
    [_gameViewController release];
    
    [super dealloc];
}


@end
