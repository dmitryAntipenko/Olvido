//
//  OGAudioManager.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface OGAudioManager : NSObject

@property (nonatomic, weak) id<AVAudioPlayerDelegate> musicPlayerDelegate;
@property (nonatomic, assign, readonly) BOOL isMusicPlaying;

+ (instancetype)audioManager;

- (void)playMusic:(NSString *)filename;
- (void)playSoundEffect:(NSString *)filename;

- (void)stopMusic;
- (void)resumeMusic;
- (void)pauseMusic;

@end
