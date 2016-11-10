//
//  OGLoadSceneOperation.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadSceneOperation.h"
#import "OGSceneMetadata.h"
#import "OGBaseScene.h"

NSUInteger const kOGLOadSceneOperationProgressTotalUnitCount = 1;

@interface OGLoadSceneOperation ()

@property (nonatomic, strong) OGSceneMetadata *sceneMetadata;
@property (nonatomic, strong, readwrite) OGBaseScene *scene;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGLoadSceneOperation

- (instancetype)initWithSceneMetadata:(OGSceneMetadata *)sceneMetadata
{
    if (sceneMetadata)
    {
        self = [self init];
        
        if (self)
        {
            _sceneMetadata = sceneMetadata;
            _progress = [NSProgress progressWithTotalUnitCount:kOGLOadSceneOperationProgressTotalUnitCount];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)loadSceneOperationWithSceneMetadata:(OGSceneMetadata *)sceneMetadata
{
    return [[OGLoadSceneOperation alloc] initWithSceneMetadata:sceneMetadata];
}

- (void)start
{
    if (!self.isCancelled)
    {
        if (self.progress.isCancelled)
        {
            [self cancel];
        }
        else
        {
            self.scene = [[self.sceneMetadata.sceneClass alloc] initWithFileNamed:self.sceneMetadata.fileName];
            
            [self.scene createCamera];
            self.progress.completedUnitCount = kOGLOadSceneOperationProgressTotalUnitCount;
        }
    }
}

@end
