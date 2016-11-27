//
//  OGSceneMetadata.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneMetadata.h"

NSString *const OGSceneMetadataOnDemandResourcesKey = @"OnDemandResources";
NSString *const OGSceneMetadataClassNameKey = @"ClassName";
NSString *const OGSceneMetadataFileNameKey = @"FileName";
NSString *const OGSceneMetadataTextureAtlasesKey = @"TextureAtlases";

@implementation OGSceneMetadata

- (instancetype)initWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;
{
    if (configuration)
    {
        self = [self init];
        
        if (self)
        {
            NSString *className = [configuration objectForKey:OGSceneMetadataClassNameKey];
            NSString *fileName = [configuration objectForKey:OGSceneMetadataFileNameKey];
            
            if (className && fileName)
            {
                _sceneClass = NSClassFromString(className);
                _fileName = fileName;
                _identifier = identifier;
                _textureAtlases = [configuration objectForKey:OGSceneMetadataTextureAtlasesKey];
                
                if (!_textureAtlases)
                {
                    _textureAtlases = [[NSDictionary alloc] init];
                }
                
                NSArray<NSString *> *onDemandResourcesClassNames = configuration[OGSceneMetadataOnDemandResourcesKey];
                
                NSMutableArray *mutableLoadableClasses = [NSMutableArray array];
                
                if (onDemandResourcesClassNames)
                {
                    for (NSString *resourceLoadableClassName in onDemandResourcesClassNames)
                    {
                        Class loadableClass = NSClassFromString(resourceLoadableClassName);
                        
                        if ([loadableClass conformsToProtocol:@protocol(OGResourceLoadable)])
                        {
                            [mutableLoadableClasses addObject:loadableClass];
                        }
                    }
                }
                
                _loadableClasses = mutableLoadableClasses;
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
