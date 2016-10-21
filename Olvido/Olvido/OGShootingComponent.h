//
//  OGShootingComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGShootingComponent : GKComponent

@property (nonatomic, assign) CGFloat shootingSpeed;

- (instancetype)initWithShell:(SKNode *)shell shooter:(SKNode *)shooter lifeTime:(NSTimeInterval)time;

- (void)shootWithVector:(CGVector)vector;
- (void)endlessShootingWithTimeInterval:(NSTimeInterval)interval;

@end
