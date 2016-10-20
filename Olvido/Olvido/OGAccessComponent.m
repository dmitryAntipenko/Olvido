//
//  OGAccessComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAccessComponent.h"

@implementation OGAccessComponent

- (void)grantAccessWithCompletionBlock:(void (^)())completion
{
    completion();
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.componentDelegate)
    {
        [self.componentDelegate checkAccess];
    }
}

@end
