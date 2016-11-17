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

NSString *const kOGSoundComponentActionKey = @"Olvido.SoundComponent.PlaySoundAction";

@implementation OGSoundComponent

- (void)playSoundOnce:(NSString *)soundName
{    
    [self.target removeActionForKey:kOGSoundComponentActionKey];
    
    SKAction *playAction = [SKAction playSoundFileNamed:soundName waitForCompletion:NO];
    [self.target runAction:playAction withKey:kOGSoundComponentActionKey];
}

@end
