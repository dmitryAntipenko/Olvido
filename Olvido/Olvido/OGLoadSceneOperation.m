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
#import "OGConstants.h"
#import "OGGameScene.h"
#import "GKScene+OGFactory.h"

NSString *const OGLoadSceneOperationGraphsKey = @"Graphs";

@interface OGLoadSceneOperation ()

@property (nonatomic, strong) OGSceneMetadata *sceneMetadata;
@property (nonatomic, strong, readwrite) OGBaseScene *scene;

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

- (void)main
{
    if (!self.isCancelled)
    {
        GKScene *gkScene = nil;
        
        if (self.sceneMetadata.isDeviceIdiomSensitive)
        {
            gkScene =[GKScene sceneWithMetadata:self.sceneMetadata
                                userDeviceIdion:[[UIDevice currentDevice] userInterfaceIdiom]];
        }
        else
        {
            gkScene = [GKScene sceneWithMetadata:self.sceneMetadata];
        }
        
        self.scene = (OGBaseScene *)gkScene.rootNode;
        [self.scene configureScene];
    }
}

- (BOOL)isAsynchronous
{
    return YES;
}

@end
