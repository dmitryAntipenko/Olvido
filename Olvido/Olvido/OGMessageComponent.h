//
//  OGMessageComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMessageComponent : GKComponent

@property (nonatomic, strong) GKInspectable NSString *tset;

- (instancetype)initWithTarget:(SKSpriteNode *)target minShowDistance:(CGFloat)distance;

- (void)addMessage:(NSString *)message forSprite:(SKSpriteNode *)sprite;

@end
