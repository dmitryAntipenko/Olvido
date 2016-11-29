//
//  OGLoadResourcesOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadLoadableClassOperation.h"
#import "OGResourceLoadable.h"

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
        if ([self.loadableClass resourcesNeedLoading])
        {
            [self.loadableClass loadResourcesWithCompletionHandler:^
             {
                 //temporary
             }];
        }
    }
}

@end
