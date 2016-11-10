//
//  OGLoadOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadOperation.h"

@implementation OGLoadOperation

- (BOOL)isExecuting
{
    return self.state == executingState;
}

- (BOOL)isFinished
{
    return self.state == finishedState;
}

- (BOOL)isCancelled
{
    return self.state == canceledState;
}

@end
