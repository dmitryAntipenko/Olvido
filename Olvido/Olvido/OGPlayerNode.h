//
//  OGPlayer.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBasicGameNode.h"

extern CGFloat const kOGPlayerNodeBorderLineWidth;

@interface OGPlayerNode : OGBasicGameNode

+ (instancetype)playerNodeWithColor:(SKColor *)color;

- (void)moveToPoint:(CGPoint)point;

- (void)positionDidUpdate;

- (void)moveByInertia;

- (void)changeSpeedCoefficient:(CGFloat)speedCoefficient;

@end
