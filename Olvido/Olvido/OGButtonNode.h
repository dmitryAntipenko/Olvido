//
//  OGButtonNode.h
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

extern NSString *const OGButtonNodeUserDataTouchedTextureKey;
extern NSString *const OGButtonNodeUserDataTouchedColorKey;
extern NSString *const OGButtonNodeUserDataSelectorKey;

@class OGAudioManager;

@interface OGButtonNode : SKSpriteNode

@property (nonatomic, weak) OGAudioManager *audioManager;

@property (nonatomic, weak) id target;

- (void)doAction;

@end
