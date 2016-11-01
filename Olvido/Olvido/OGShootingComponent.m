//
//  OGShootingComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShootingComponent.h"

CGFloat const kOGShootingComponentDefaultShootingSpeed = 2.0;

@interface OGShootingComponent ()

@property (nonatomic, strong) SKNode *shell;
@property (nonatomic, strong) SKNode *shooter;
@property (nonatomic, assign) NSTimeInterval lifeTime;
@property (nonatomic, strong) NSTimer *shootingTimer;

@end

@implementation OGShootingComponent

- (instancetype)initWithShell:(SKNode *)shell shooter:(SKNode *)shooter lifeTime:(NSTimeInterval)time
{
    self = [super init];

    if (self)
    {
        if (shell && shooter && time > 0.0)
        {
            _shell = shell;
            _shooter = shooter;
            _lifeTime = time;
            _shootingSpeed = kOGShootingComponentDefaultShootingSpeed;
        }
        else
        {
            self = nil;
        }
    }
    
    return self;
}

- (void)shootWithVector:(CGVector)vector
{
    SKNode *shell = [self.shell copy];
    shell.position = self.shooter.position;
    
    CGVector shootingVector = CGVectorMake(vector.dx + vector.dx * self.shootingSpeed,
                                           vector.dy + vector.dy * self.shootingSpeed);
    
    shell.physicsBody.velocity = shootingVector;
    
    [self.shooter.scene addChild:shell];
    
    SKAction *wait = [SKAction waitForDuration:self.lifeTime];
    
    [shell runAction:wait completion:^()
     {
         [shell removeFromParent];
     }];
}

- (void)endlessShootingWithTimeInterval:(NSTimeInterval)interval
{
    SKAction *shootingBlock = [SKAction runBlock:^()
                               {
                                   [self shootWithVector:self.shooter.physicsBody.velocity];
                               }];
    
    SKAction *wait = [SKAction waitForDuration:interval];
    
    SKAction *shooting = [SKAction sequence:@[shootingBlock, wait]];
    
    [self.shooter runAction:[SKAction repeatActionForever:shooting]];
}

- (void)dealloc
{
    [_shootingTimer invalidate];
    
}

@end
