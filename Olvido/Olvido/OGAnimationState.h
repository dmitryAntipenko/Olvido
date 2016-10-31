//
//  OGAnimationState.h
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGAnimationState : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSArray<SKTexture *> *textures;

+ (instancetype)animationStateWithName:(NSString *)name textures:(NSArray<SKTexture *> *)textures validNextStates:(NSArray<NSString *> *)validStates;

- (BOOL)isValidNextState:(OGAnimationState *)nextState;

@end
