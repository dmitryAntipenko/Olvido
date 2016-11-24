//
//  OGSoundComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSoundComponent.h"
#import "OGRenderComponent.h"

NSString *const kOGSoundComponentActionKey = @"Olvido.SoundComponent.PlaySoundAction";

@interface OGSoundComponent ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SKAudioNode *> *soundNodes;

@end

@implementation OGSoundComponent

- (instancetype)initWithSoundNames:(NSArray<NSString *> *)names
{
    if (names)
    {
        self = [super init];
        
        if (self)
        {            
            _soundNodes = [NSMutableDictionary dictionary];
        
            for (NSString *name in names)
            {
                SKAudioNode *node = [[SKAudioNode alloc] initWithFileNamed:name];
                node.autoplayLooped = NO;                
                [_soundNodes setObject:node forKey:name];
            }
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)setTarget:(SKNode *)target
{
    _target = target;
    
    [self.soundNodes enumerateKeysAndObjectsUsingBlock:^(NSString *key, SKAudioNode *node, BOOL *stop)
    {
        [node removeFromParent];
        [self.target addChild:node];
    }];
}

- (void)playSoundOnce:(NSString *)soundName
{
    [self.soundNodes[soundName] removeActionForKey:kOGSoundComponentActionKey];
    [self.soundNodes[soundName] runAction:[SKAction play] withKey:kOGSoundComponentActionKey];
}

@end
