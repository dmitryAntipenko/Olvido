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
@property (nonatomic, assign) GKInspectable CGFloat speed;
@property (nonatomic, assign) GKInspectable CGFloat dx;
@property (nonatomic, assign) GKInspectable CGFloat dy;

@property (nonatomic, strong) SKPhysicsBody *physicsBody;

- (void)startMovement;

@end
