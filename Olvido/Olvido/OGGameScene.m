//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

#import "OGEntity.h"
#import "OGVisualComponent.h"
#import "OGTransitionComponent.h"
#import "OGSpriteNode.h"

@implementation OGGameScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _enemies = [[NSMutableArray alloc] init];
        _portals = [[NSMutableArray alloc] init];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)createSceneContents
{
    
}

- (void)addPortal:(OGEntity *)portal
{
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
    OGVisualComponent *visualComponent = (OGVisualComponent *) [portal componentForClass:[OGVisualComponent class]];
    
    if (transitionComponent)
    {
        if (transitionComponent.location == kOGPortalLocationUp)
        {
            visualComponent.spriteNode.position = CGPointMake(CGRectGetMidX(self.frame), 0.0);
        }
        else if (transitionComponent.location == kOGPortalLocationDown)
        {
            visualComponent.spriteNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
        }
        else if (transitionComponent.location == kOGPortalLocationLeft)
        {
            visualComponent.spriteNode.position = CGPointMake(0.0, CGRectGetMidY(self.frame));
        }
        else if (transitionComponent.location == kOGPortalLocationRight)
        {
            visualComponent.spriteNode.position = CGPointMake(self.frame.size.width, CGRectGetMidY(self.frame));
        }
    }
    
    [self.portals addObject:portal];
    [self addChild:visualComponent.spriteNode];
}

- (void)dealloc
{
    [_enemies release];
    [_player release];
    [_identifier release];
    [_portals release];
    [_sceneDelegate release];
    
    [super dealloc];
}

@end
