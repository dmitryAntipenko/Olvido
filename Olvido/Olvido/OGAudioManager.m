//
//  OGAudioManager.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "OGAudioManager.h"

@interface OGAudioManager ()

@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) AVAudioPlayer *effectPlayer;

@end

@implementation OGAudioManager

#pragma mark - Initializer

+ (instancetype)audioManager
{
    return [[OGAudioManager alloc] init];
}

#pragma mark - Getters & setters

- (void)setMusicPlayerDelegate:(id<AVAudioPlayerDelegate>)playerDelegate
{
    self.musicPlayer.delegate = playerDelegate;
}

- (id<AVAudioPlayerDelegate>)musicPlayerDelegate
{
    return self.musicPlayer.delegate;
}

- (BOOL)isMusicPlaying
{
    return self.musicPlayer && self.musicPlayer.isPlaying;
}

#pragma mark - Audio managing

- (AVAudioPlayer *)playerWithSound:(NSString *)filename
{
    NSDataAsset *dataAsset = [[NSDataAsset alloc] initWithName:filename];
    AVAudioPlayer *result = nil;
    
    if (dataAsset)
    {
        NSError *error = nil;
        result = [[AVAudioPlayer alloc] initWithData:dataAsset.data error:&error];
        
        if (error)
        {
            result = nil;
        }
    }
    
    return result;
}

- (void)playSoundEffect:(NSString *)filename
{
    self.effectPlayer = [self playerWithSound:filename];
    [self.effectPlayer play];
}

- (void)playMusic:(NSString *)filename
{
    self.musicPlayer = [self playerWithSound:filename];
    [self.musicPlayer play];
}

- (void)stopMusic
{
    if (self.musicPlayer && self.musicPlayer.isPlaying)
    {
        [self.musicPlayer stop];
    }
}

- (void)pauseMusic
{
    if (self.musicPlayer && self.musicPlayer.isPlaying)
    {
        [self.musicPlayer pause];
    }
}

- (void)resumeMusic
{
    if (self.musicPlayer && !self.musicPlayer.isPlaying)
    {
        [self.musicPlayer play];
    }
}

@end
