//
//  OGLoadTexturesOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadTexturesOperation.h"
#import "OGTextureAtlasesManager.h"

NSString *const OGLoadTexturesOperationIsFinishedKey = @"isFinished";

@interface OGLoadTexturesOperation ()

@property (nonatomic, strong) NSString *unitName;
@property (nonatomic, strong) NSString *atlasName;
@property (nonatomic, strong) NSString *atlasKey;
@property (nonatomic, assign) BOOL customIsFinished;

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
    }
    
    return self;
}

- (void)main
{
    if (!self.isCancelled)
    {
        OGTextureAtlasesManager *textureAtlasesManager = [OGTextureAtlasesManager sharedInstance];
        
        if (self.atlasKey && self.unitName && self.atlasName)
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:self.atlasName];
            
            [textureAtlasesManager addAtlasWithUnitName:self.unitName atlasKey:self.atlasKey atlas:atlas];
            
            __weak typeof(self) weakSelf = self;
            
            [atlas preloadWithCompletionHandler:^
             {
                 if (weakSelf)
                 {
                     typeof(weakSelf) strongSelf = weakSelf;
                     
                     [strongSelf willChangeValueForKey:OGLoadTexturesOperationIsFinishedKey];
                     strongSelf.customIsFinished = YES;
                     [strongSelf didChangeValueForKey:OGLoadTexturesOperationIsFinishedKey];
                 }
             }];
        }
    }
}

- (BOOL)isFinished
{
    return self.customIsFinished;
}

- (BOOL)isAsynchronous
{
    return YES;
}

@end
