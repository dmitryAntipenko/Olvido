//
//  OGMessageComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMessageComponent : GKComponent

- (instancetype)initWithTarget:(SKSpriteNode *)target minShowDistance:(CGFloat)distance labelNode:(SKLabelNode *)labelNode;

- (void)showMessage:(NSString *)message duration:(CGFloat)duration shouldOverlay:(BOOL)shouldOverlay;
- (void)addMessage:(NSString *)message forSprite:(SKSpriteNode *)sprite;

@end
