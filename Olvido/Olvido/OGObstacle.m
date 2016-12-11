//
//  OGObstacle.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstacle.h"
#import "OGColliderType.h"

#import "OGPhysicsComponent.h"

@implementation OGObstacle

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.size];
    
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        self.physicsComponent.physicsBody.categoryBitMask = [OGColliderType obstacle].categoryBitMask;
        self.physicsComponent.physicsBody.collisionBitMask = [OGColliderType obstacle].collisionBitMask;
        self.physicsComponent.physicsBody.contactTestBitMask = [OGColliderType obstacle].contactTestBitMask;
        
        self.physicsComponent.physicsBody.dynamic = NO;
    }
    
    return self;
}

@end
