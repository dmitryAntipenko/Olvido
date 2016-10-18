//
//  OGConstants.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGConstants_h
#define OGConstants_h

#import <SpriteKit/SpriteKit.h>

extern NSString *const kOGPlayerNodeName;
extern NSString *const kOGEnemyNodeName;
extern NSString *const kOGObstacleNodeName;
extern NSString *const kOGCoinNodeName;
extern NSString *const kOGPortalNodeName;

extern NSString *const kOGEnemyTextureName;
extern NSString *const kOGPlayerTextureName;

extern NSUInteger const kOGLevelsCount;

extern CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount;
extern CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration;

extern CGFloat const kOGGameNodeDefaultSpeed;

extern NSString *const kOGSceneControllerHorizontalPortalTextureName;
extern NSString *const kOGSceneControllerVerticalPortalTextureName;

@interface OGConstants : NSObject

+ (CGPoint)randomPointInRect:(CGRect)rect;
+ (CGVector)randomVectorWithLength:(CGFloat)length;

@end

#endif /* OGConstants_h */
