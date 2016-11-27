//
//  OGLoadTexturesOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadTexturesOperation.h"
#import "OGTextureAtlasesManager.h"

NSUInteger const kOGLoadTexturesOperationProgressTotalUnitCount = 1;

@interface OGLoadTexturesOperation ()

@property (nonatomic, strong) NSString *unitName;
@property (nonatomic, strong) NSString *atlasName;
@property (nonatomic, strong) NSString *atlasKey;

@end

@implementation OGLoadTexturesOperation

+ (instancetype)loadTexturesOperationWithUnitName:(NSString *)unitName
                                         atlasKey:(NSString *)atlasKey
                                        atlasName:(NSString *)atlasName
{
    return [[self alloc] initWithUnitName:unitName atlasKey:atlasKey atlasName:atlasName];
}

- (instancetype)initWithUnitName:(NSString *)unitName
                        atlasKey:(NSString *)atlasKey
                       atlasName:(NSString *)atlasName
{
    self = [self init];
    
    if (self)
    {
        _unitName = unitName;
        _atlasName = atlasName;
        _atlasKey = atlasKey;
        
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
            OGTextureAtlasesManager *textureAtlasesManager = [OGTextureAtlasesManager sharedInstance];
            
            if (self.atlasKey
                && self.unitName
                && self.atlasName
                && ![textureAtlasesManager containsAtlasWithKey:self.atlasKey unitName:self.unitName])
            {
                SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:self.atlasName];
                
                [textureAtlasesManager addAtlasWithUnitName:self.unitName atlasKey:self.atlasKey atlas:atlas];
                
                __weak typeof(self) weakSelf = self;
                [atlas preloadWithCompletionHandler:^
                 {
                     if (weakSelf)
                     {
                         typeof(weakSelf) strongSelf = weakSelf;
                         
                         [strongSelf finish];
                     }
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
    self.progress.completedUnitCount = kOGLoadTexturesOperationProgressTotalUnitCount;
}

@end
