//
//  OGMenuBaseScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMenuBaseScene.h"
#import "OGMenuManager.h"
#import "OGButtonNode.h"

@implementation OGMenuBaseScene

- (void)onButtonClick:(OGButtonNode *)button
{
    [self.menuManager.audioManager playSoundEffect:@"button_touch"];
}

@end
