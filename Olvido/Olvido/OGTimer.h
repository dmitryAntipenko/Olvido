//
//  OGTimer.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTimer : SKNode

@property (nonatomic, assign) NSNumber *ticks;

- (void)start;
- (void)startWithSelector:(SEL)selector sender:(id)sender;
- (void)stop;

@end
