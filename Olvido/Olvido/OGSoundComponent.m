//
//  OGSoundComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSoundComponent.h"
#import <AVFoundation/AVFoundation.h>

@implementation OGSoundComponent

- (void)playSoundOnce:(NSString *)soundName
{
    SKAudioNode *node = [[SKAudioNode alloc] initWithFileNamed:soundName];
    node.autoplayLooped = NO;    
    
    [self.target addChild:node];
    
    [node runAction:[SKAction play]];
    
    //[node removeFromParent];
}

@end
