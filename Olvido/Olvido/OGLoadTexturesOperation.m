//
//  OGLoadTexturesOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadTexturesOperation.h"

NSUInteger const kOGLoadTexturesOperationProgressTotalUnitCount = 1;

@interface OGLoadTexturesOperation ()

@property (nonatomic, strong) NSString *unitName;
@property (nonatomic, strong) NSString *atlasName;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGLoadTexturesOperation

+ (instancetype)loadTexturesOperationWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName
{
    return [[self alloc] initWithUnitName:unitName atlasName:atlasName];
}

- (instancetype)initWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName;
{
    self = [self init];
    
    if (self)
    {
        _unitName = unitName;
        _atlasName = atlasName;
        
        _progress = [[NSProgress alloc] init];
        _progress.totalUnitCount = kOGLoadTexturesOperationProgressTotalUnitCount;
    }
    
    return self;
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
            if (self.unitName && self.atlasName)
            {
                [self.loadableClass loadResourcesWithCompletionHandler:^
                 {
                     [weakSelf finish];
                 }];
            }
//            
//            if ([self.loadableClass resourcesNeedLoading])
//            {
//                __block typeof(self) weakSelf = self;
//                
//                [self.loadableClass loadResourcesWithCompletionHandler:^
//                 {
//                     [weakSelf finish];
//                 }];
//            }
            else
            {
                [self finish];
            }
        }
    }
}



- (void)finish
{
    self.progress.completedUnitCount = kOGLoadTexturesOperationProgressTotalUnitCount;
}

@end
