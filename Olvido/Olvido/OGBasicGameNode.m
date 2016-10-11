//
//  OGBasicGameItem.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBasicGameNode.h"

CGFloat const kOGBasicGameNodeRadius = 16.0;

CGFloat const kOGBasicGameNodeDefaultVelocityX = 0.0;
CGFloat const kOGBasicGameNodeDefaultVelocityY = 0.0;

@interface OGBasicGameNode()

@property (nonatomic, retain) SKSpriteNode *skin;

@end

@implementation OGBasicGameNode

- (instancetype)initWithColor:(SKColor *)color
                       radius:(CGFloat)radius
                     velocity:(CGVector)velocity
                   appearance:(SKSpriteNode *)appearence
                         skin:(SKSpriteNode *)skin
{
    self = [super init];
    
    if (self)
    {
        _color = [color retain];
        _radius = radius;
        _velocity = velocity;
        _appearance = [appearence retain];
        _skin = [skin retain];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (instancetype)initWithColor:(SKColor *)color
{
    return [self initWithColor:color
                        radius:kOGBasicGameNodeRadius
                      velocity:CGVectorMake(kOGBasicGameNodeDefaultVelocityX, kOGBasicGameNodeDefaultVelocityY)
                    appearance:nil
                          skin:nil];
}

- (void)dealloc
{
    [_color release];
    [_appearance release];
    [_skin release];
    
    [super dealloc];
}

- (CGFloat)diameter
{
    return self.radius * 2.0;
}

- (void)moveToPoint:(CGPoint)point
{
    
}

@end
