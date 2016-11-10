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

- (instancetype)initWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;
{
    if (configuration)
    {
        self = [self init];
        
        if (self)
        {
            NSString *sceneClass = [configuration objectForKey:kOGSceneMetadataSceneTypeKey];
            NSString *name = [configuration objectForKey:kOGSceneMetadataSceneNameKey];
            
            if (sceneClass && name)
            {
                _sceneClass = NSClassFromString(sceneClass);
                _name = name;
                _identifier = identifier;
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

+ (instancetype)sceneMetaDataWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;
{
    return [[OGSceneMetadata alloc] initWithSceneConfiguration:configuration identifier:identifier];
}

@end
