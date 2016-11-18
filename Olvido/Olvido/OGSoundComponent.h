//
//  OGSoundComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGSoundComponent : GKComponent

@property (nonatomic, weak) SKNode *target;

- (instancetype)initWithSoundNames:(NSArray *)names;

- (void)playSoundOnce:(NSString *)soundName;

@end
