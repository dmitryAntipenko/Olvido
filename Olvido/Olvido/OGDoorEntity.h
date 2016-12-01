//
//  OGDoorEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGResourceLoadable.h"
#import "OGTransitionComponent.h"
#import "OGTransitionComponentDelegate.h"

@class OGDoorConfiguration;

@interface OGDoorEntity : GKEntity <OGContactNotifiableType, OGResourceLoadable>

@property (nonatomic, weak) id<OGTransitionComponentDelegate> transitionDelegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode configuration:(OGDoorConfiguration *)configuration;

- (void)lock;
- (void)unlock;

@end
