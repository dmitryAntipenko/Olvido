//
//  OGSoundComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "OGSoundComponent.h"
#import "OGRenderComponent.h"

@interface OGSoundComponent ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SKAudioNode *> *soundNodes;

@end

@implementation OGSoundComponent

- (instancetype)init
{
    return [self initWithSoundNodes:nil];
}

- (instancetype)initWithSoundNodes:(NSArray<SKAudioNode *> *)nodes
{
    self = [super init];
    
    if (self)
    {            
        _soundNodes = [NSMutableDictionary dictionary];
    
        for (SKAudioNode *audioNode in nodes)
        {
            [_soundNodes setObject:audioNode forKey:audioNode.name];
        }
    }
    
    return self;
}

- (void)setTarget:(SKNode *)target
{
    _target = target;
    
    for (NSString *key in self.soundNodes.allKeys)
    {
        [self.soundNodes[key] removeFromParent];
    }
}

#pragma mark - Playing sounds

- (void)playSoundContinuously:(NSString *)soundName
{
    SKAudioNode *node = self.soundNodes[soundName];
    
    if (!node)
    {
        node = [[SKAudioNode alloc] initWithFileNamed:soundName];
        [self.soundNodes setObject:node forKey:soundName];
    }
    
    if (!self.soundNodes[soundName].parent)
    {
        [self.target addChild:self.soundNodes[soundName]];
    }
}

- (void)stopPlayingSound:(NSString *)soundName
{
    [self.soundNodes[soundName] runAction:[SKAction stop]];
    [self.soundNodes[soundName] removeFromParent];
}

- (void)playSoundOnce:(NSString *)soundName
{
    SKAudioNode *audioNode = self.soundNodes[soundName];
    
    if (audioNode)
    {
        [self stopPlayingSound:soundName];
        
        if (!audioNode.parent)
        {
            [self.target addChild:audioNode];
        }
        
        [audioNode runAction:[SKAction play]];
    }
}

#pragma mark - Actions

- (void)changeVolumeBy:(CGFloat)volume duration:(CGFloat)duration
{
    SKAction *action = [SKAction changeVolumeBy:volume duration:duration];
    [self runActionOnSoundNodes:action];
}

- (void)changeVolumeTo:(CGFloat)volume duration:(CGFloat)duration
{
    SKAction *action = [SKAction changeVolumeTo:volume duration:duration];
    [self runActionOnSoundNodes:action];
}

- (void)runActionOnSoundNodes:(SKAction *)action
{
    for (NSString *key in self.soundNodes.allKeys)
    {
        [self.soundNodes[key] runAction:action];
    }
}

@end
