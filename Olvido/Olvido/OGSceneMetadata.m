//
//  OGSceneMetadata.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneMetadata.h"

NSString *const kOGSceneMetadataIdentifierKey = @"Identifier";
NSString *const kOGSceneMetadataSceneTypeKey = @"Type";
NSString *const kOGSceneMetadataSceneNameKey = @"Name";

NSString *const kOGSceneMetadataSceneTypeLevel = @"SceneTypeLevel";
NSString *const kOGSceneMetadataSceneTypeMenu = @"SceneTypeMenu";
NSString *const kOGSceneMetadataSceneTypeStory = @"SceneTypeStory";

@implementation OGSceneMetadata

- (instancetype)initWithSceneConfiguration:(NSDictionary *)configuration
{
    if (configuration)
    {
        self = [self init];
        
        if (self)
        {
            NSNumber *identifier = [configuration valueForKey:kOGSceneMetadataIdentifierKey];
            NSString *sceneType = [configuration valueForKey:kOGSceneMetadataSceneTypeKey];
            NSString *name = [configuration valueForKey:kOGSceneMetadataSceneNameKey];
            
            if (identifier && sceneType && name)
            {
                _identifier = identifier;
                _sceneType = sceneType;
                _name = name;
            }
            else
            {
                self = nil;
            }
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)sceneMetaDataWithSceneConfiguration:(NSDictionary *)configuration
{
    return [[OGSceneMetadata alloc] initWithSceneConfiguration:configuration];
}

@end
