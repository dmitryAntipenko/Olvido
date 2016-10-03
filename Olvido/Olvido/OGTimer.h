//
//  OGTimer.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTimer : NSObject

@property (nonatomic, retain, readonly) NSNumber *ticks;

- (void)start;
- (void)startWithSelector:(SEL)selector sender:(id)sender;
- (void)tick;
- (void)stop;

@end
