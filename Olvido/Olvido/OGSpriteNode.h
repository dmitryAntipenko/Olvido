//
//  OGSpriteNode.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class OGVisualComponent;

@interface OGSpriteNode : SKSpriteNode

@property (nonatomic, assign) OGVisualComponent *owner;

@end
