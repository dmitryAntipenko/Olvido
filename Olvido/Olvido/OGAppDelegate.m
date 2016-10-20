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

@interface OGAppDelegate ()

@property (nonatomic, assign, assign) OGGameViewController *gameViewController;

@end

@implementation OGAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.gameViewController = (OGGameViewController *)self.window.rootViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if ([self.gameViewController.uiStateMachine canEnterState:[OGPauseState class]])
    {
        [self.gameViewController.uiStateMachine enterState:[OGPauseState class]];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([self.gameViewController.uiStateMachine canEnterState:[OGPauseState class]])
    {
        [self.gameViewController.uiStateMachine enterState:[OGPauseState class]];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([self.gameViewController.uiStateMachine canEnterState:[OGGameState class]])
    {
        [self.gameViewController.uiStateMachine enterState:[OGGameState class]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([self.gameViewController.uiStateMachine canEnterState:[OGGameState class]])
    {
        [self.gameViewController.uiStateMachine enterState:[OGGameState class]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)dealloc
{
    [_window release];
    
    [super dealloc];
}

@end
