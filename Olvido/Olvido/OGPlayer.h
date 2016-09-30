//
//  OGPlayer.h
//  Olvido
//
//  Created by Александр Песоцкий on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const kOGPlayerPlayerName;
extern CGFloat const kOGPlayerPlayerRadius;

@interface OGPlayer : SKSpriteNode

+ (instancetype)playerWithTexture:(SKTexture *)texture inPoint:(CGPoint)point;

@end
