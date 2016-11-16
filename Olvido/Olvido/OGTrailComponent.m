//
//  OGTrailComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrailComponent.h"
#import "OGMovementComponent.h"

@interface OGTrailComponent ()

@property (nonatomic, strong) SKTexture *trailTexture;
@property (nonatomic, strong, readonly) OGMovementComponent *movementComponent;

@end

@implementation OGTrailComponent

@synthesize movementComponent = _movementComponent;

- (instancetype)initWithTexture:(SKTexture *)trailTexture
{
    if (trailTexture)
    {
        self = [self init];
        
        if (self)
        {
            _trailTexture = trailTexture;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)trailComponentWithTexture:(SKTexture *)trailTexture
{
    return [[self alloc] initWithTexture:trailTexture];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
//    [self.targetNode addChild]
}

- (OGMovementComponent *)movementComponent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _movementComponent = (OGMovementComponent *)[self.entity componentForClass:OGMovementComponent.self];
    });
    
    return _movementComponent;
}

@end
