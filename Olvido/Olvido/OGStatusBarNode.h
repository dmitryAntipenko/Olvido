//
//  OGStatusBarNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGStatusBarNode : SKSpriteNode

@property (nonatomic, retain) SKLabelNode *scoreLabel;

+ (instancetype)statusBarNode;

@end
