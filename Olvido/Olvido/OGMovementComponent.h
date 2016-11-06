//
//  OGMovement.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMovementComponent : GKComponent

@property (nonatomic, assign) CGVector displacementVector;
@property (nonatomic, assign) CGPoint destinationPoint;
@property (nonatomic, assign) CGPoint direction;

@property (nonatomic, assign) CGFloat speedFactor;

@end
