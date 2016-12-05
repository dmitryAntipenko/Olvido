//
//  OGAidKit.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAidKit.h"
#import "OGHealthComponentDelegate.h"
#import "OGRenderComponent.h"

NSString *const OGAidKitHealingPointsKey = @"healingPoints";

@interface OGAidKit () <OGHealthComponentDelegate>

@property (nonatomic, assign) NSInteger healingPoints;

@end

@implementation OGAidKit

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        self = [super initWithSpriteNode:spriteNode];
        
        if (self)
        {
            _healingPoints = [spriteNode.userData[OGAidKitHealingPointsKey] integerValue];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [super contactWithEntityDidBegin:entity];
    
    [self.healthComponentDelegate restoreEntityHealth:self.healingPoints];
    [self.delegate removeEntity:self];
}

@end
