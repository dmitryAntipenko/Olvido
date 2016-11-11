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

NSString *const kOGAppDelegateMainStoryboardName = @"Main";

@interface OGAppDelegate ()

@property (nonatomic, strong) OGGameViewController *gameViewController;

@end

@implementation OGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:kOGAppDelegateMainStoryboardName bundle:nil];
    
    self.gameViewController = [mainStoryboard instantiateInitialViewController];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    self.window.rootViewController = self.gameViewController;
    [self.window makeKeyAndVisible];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"%@", name);
        }
    }
    
    return YES;
}



@end
