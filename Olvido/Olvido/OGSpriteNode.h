//
//  OGSpriteNode.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGEntity;

@interface OGSpriteNode : SKSpriteNode

@property (nonatomic, retain) OGEntity *entity;

@end
