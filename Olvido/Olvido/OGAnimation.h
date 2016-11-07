//
//  OGAnimation.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGAnimationState.h"

@interface OGAnimation : NSObject

@property (nonatomic, strong) NSString *bodyActionName;
@property (nonatomic, strong) NSArray<SKTexture *> *textures;
@property (nonatomic, assign) OGAnimationState animationState;
@property (nonatomic, assign, getter=isRepeatedTexturesForever) BOOL repeatTexturesForever;
@property (nonatomic, assign) NSInteger frameOffset;
@property (nonatomic, strong) SKAction *bodyAction;
@property (nonatomic, strong) NSArray<SKTexture *> *offsetTextures;

@end
