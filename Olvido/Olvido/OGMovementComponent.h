//
//  OGMovement.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMovementComponent : GKComponent

@property (nonatomic, assign) GKInspectable CGFloat speedFactor;

- (instancetype)initWithPhysicsBody:(SKPhysicsBody *)body;

- (void)startMovementWithSpeed:(CGFloat)speed vector:(CGVector)vectro;

@end
