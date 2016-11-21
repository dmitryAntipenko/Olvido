//
//  OGOrientationComponent.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGDirection.h"

@interface OGOrientationComponent : GKComponent

@property (nonatomic, assign) OGDirection direction;

+ (OGDirection)directionWithVectorX:(CGFloat)vectorX;

@end
