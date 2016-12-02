//
//  OGAidKit.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGSceneItemEntity.h"
#import "OGHealthComponentDelegate.h"

@interface OGAidKit : OGSceneItemEntity

@property (nonatomic, weak) id<OGHealthComponentDelegate> healthComponentDelegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

@end
