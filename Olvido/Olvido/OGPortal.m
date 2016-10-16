//
//  OGPortal.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPortal.h"
#import "OGCollisionBitMask.h"

NSString *const kOGPortalHorizontalTextureName = @"PortalHorizontal";
NSString *const kOGPortalVerticalTextureName = @"PortalVertical";

@interface OGPortal ()

@property (nonatomic, retain) SKSpriteNode *appearance;

@end

@implementation OGPortal

+ (instancetype)portalWithLocation:(OGPortalLocation)location
{
    OGPortal *portal = [[OGPortal alloc] init];
    
    if (portal)
    {
        SKTexture *portalTexture = nil;
        
        if (location == kOGPortalLocationUp || location == kOGPortalLocationDown)
        {
            portalTexture = [SKTexture textureWithImageNamed:kOGPortalHorizontalTextureName];
        }
        else if (location == kOGPortalLocationRight || location == kOGPortalLocationLeft)
        {
            portalTexture = [SKTexture textureWithImageNamed:kOGPortalVerticalTextureName];
        }
        
        SKSpriteNode *portalAppearance = [SKSpriteNode spriteNodeWithTexture:portalTexture];
        [portal addChild:portalAppearance];
        portal.appearance = portalAppearance;
        
        portal.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:portal.appearance.size];
        portal.physicsBody.categoryBitMask = kOGCollisionBitMaskPortal;
        portal.physicsBody.
        
        portal.location = location;
        portal.closed = NO;
    }
    
    return [portal autorelease];
}

- (void)setColor:(UIColor *)color
{
    if (_color != color)
    {
        [_color release];
        _color = [color retain];
        
        _appearance.color = _color;
    }
}

@end
