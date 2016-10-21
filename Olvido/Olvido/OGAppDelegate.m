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
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    [self.gameViewController pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.gameViewController resume];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.gameViewController resume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_gameViewController release];
}

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}


@end
