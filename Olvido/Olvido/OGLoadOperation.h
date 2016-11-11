//
//  OGLoadOperation.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OGLoadOperationState)
{
    executingState = 0,
    finishedState = 1,
    canceledState = 2
};

extern NSString *const kOGLoadOperationKeyPathForIsFinishedValue;
extern NSString *const kOGLoadOperationKeyPathForIsCanceledValue;
extern NSString *const kOGLoadOperationKeyPathForisExecutingValue;

@interface OGLoadOperation : NSOperation

@property (nonatomic, unsafe_unretained) OGLoadOperationState state;

@end
