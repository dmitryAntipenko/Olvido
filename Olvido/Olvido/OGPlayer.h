//
//  OGPlayer.h
//  Olvido
//
//  Created by Александр Песоцкий on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const kOGGameScenePlayerImageName;
extern NSString *const kOGPlayerPlayerName;
extern CGFloat const kOGPlayerPlayerRadius;
extern CGFloat const kOGPlayerPlayerSpeed;

@interface OGPlayer : SKSpriteNode

@property (nonatomic, assign) CGPoint lastPosition;

+ (instancetype)playerWithImageName:(NSString *)imageName point:(CGPoint)point;
+ (instancetype)playerWithPoint:(CGPoint)point;

- (void)changePlayerTextureWithImageName:(NSString *)imageName;
- (BOOL)isPointInPlayerWithPoint:(CGPoint)point;

- (void)changePlayerVelocityWithPoint:(CGPoint)point;

+ (CGVector)randomVelocityWithSpeed:(CGFloat)speed;

@property (nonatomic, getter=isTouched) BOOL touch;
@end
