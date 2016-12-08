//
//  OGTimer.h
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGTimer : NSObject

- (void)startWithInterval:(NSTimeInterval)interval selector:(SEL)selector sender:(id)sender;

- (void)stop;

- (void)pause;

- (void)resume;

@end
