//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "SKColor+OGConstantColors.h"
#import "OGEntity.h"
#import "OGTransitionComponent.h"

NSUInteger const kOGInitialSceneEnemiesCount = 4;

@interface OGInitialScene ()

@end

@implementation OGInitialScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor backgroundLightGrayColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [self.portals[0] componentForClass:[OGTransitionComponent class]];
    
    transitionComponent.closed = NO;
    
    [self.sceneDelegate gameSceneDidCallFinishWithPortal:self.portals[0]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
