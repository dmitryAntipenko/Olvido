//
//  OGLoadResourcesOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadLoadableClassOperation.h"
#import "OGResourceLoadable.h"

NSUInteger const OGLoadLoadableClassOperationProgressTotalUnitCount = 1;

@interface OGLoadLoadableClassOperation ()

@property (nonatomic, assign) Class<OGResourceLoadable> loadableClass;

@end

@implementation OGLoadLoadableClassOperation

- (instancetype)initWithLoadableClass:(Class<OGResourceLoadable>)loadableClass
{
    self = [self init];
    
    if (self)
    {
        _loadableClass = loadableClass;
        _progress =  [[NSProgress alloc] init];
        _progress.totalUnitCount = OGLoadLoadableClassOperationProgressTotalUnitCount;
    }
    
    return self;
}

+ (instancetype)loadResourcesOperationWithLoadableClass:(Class<OGResourceLoadable>)loadableClass
{
    return [[OGLoadLoadableClassOperation alloc] initWithLoadableClass:loadableClass];
}

- (void)main
{
    if (!self.isCancelled)
    {
        if (self.progress.isCancelled)
        {
            [self cancel];
        }
        else
        {
            if ([self.loadableClass resourcesNeedLoading])
            {
                __block typeof(self) weakSelf = self;
                
                [self.loadableClass loadResourcesWithCompletionHandler:^
                 {
                     [weakSelf finish];
                 }];
            }
            else
            {
                [self finish];
            }
        }
    }
}

- (void)finish
{
    self.progress.completedUnitCount = OGLoadLoadableClassOperationProgressTotalUnitCount;
}

@end
