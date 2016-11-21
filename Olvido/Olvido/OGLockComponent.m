//
//  OGLockComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLockComponent.h"

@interface OGLockComponent ()

@property (nonatomic, assign) SEL checkingSelector;
@property (nonatomic, weak) id performingTarget;

@end

@implementation OGLockComponent

- (void)addCheckingSelector:(SEL)selector withTarget:(id)target
{
    self.checkingSelector = selector;
    self.performingTarget = target;
}

- (void)removeCheckingSelector
{
    self.checkingSelector = nil;
    self.performingTarget = nil;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (self.checkingSelector && self.performingTarget && [self.performingTarget respondsToSelector:self.checkingSelector])
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.performingTarget performSelector:self.checkingSelector];
        #pragma clang diagnostic pop
    }
}

@end
