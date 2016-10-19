//
//  OGTorchComponent.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGTorchComponent : GKComponent

@property (nonatomic, assign) CGFloat torchRadius;

- (instancetype)initWithTorchSprite:(SKSpriteNode *)torchSprite
                       tourchRadius:(CGFloat)torchRadius;
- (void)torchTurnOn;
- (void)torchTurnOff;

- (void)createDarknessWithSize:(CGSize)size;
@end
