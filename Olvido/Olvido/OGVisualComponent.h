//
//  OGVisualComponent.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGSpriteNode;

@interface OGVisualComponent : GKComponent

@property (nonatomic, retain) OGSpriteNode *spriteNode;
@property (nonatomic, retain) SKColor *color;

@end
