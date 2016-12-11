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
#import "OGInventoryItem.h"

NSString *const OGAidKitHealingPointsKey = @"healingPoints";

@interface OGAidKit () <OGHealthComponentDelegate, OGInventoryItem>

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

#pragma mark - OGInventoryItem

- (NSString *)identifier
{
    return self.renderComponent.node.name;
}

- (SKTexture *)texture
{
    return ((SKSpriteNode *) self.renderComponent.node).texture;
}

- (void)wasSelected
{
    [self.healthComponentDelegate restoreEntityHealth:self.healingPoints];
}

@end
