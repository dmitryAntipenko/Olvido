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

@interface OGPlayer : SKSpriteNode

@property (nonatomic, assign) CGPoint lastPosition1th;
@property (nonatomic, assign) CGPoint lastPosition2th;

+ (instancetype)playerWithImageName:(NSString *)imageName point:(CGPoint)point;
+ (instancetype)playerWithPoint:(CGPoint)point;

- (void)changePlayerTextureWithImageName:(NSString *)imageName;
- (BOOL)isPointInPlayerWithPoint:(CGPoint)point;

@end
