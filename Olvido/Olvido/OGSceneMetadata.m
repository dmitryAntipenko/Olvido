//
//  OGSceneMetadata.m
//  Olvido
//
//  ; by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneMetadata.h"
#import "OGConstants.h"

NSString *const OGSceneMetadataNeedLoadDefaultResourcesKey = @"NeedLoadDefaultResources";
NSString *const OGSceneMetadataCustomResourcesFileNameKey = @"CustomResourcesFileName";
NSString *const OGSceneMetadataLoadableClassesKey = @"LoadableClasses";
NSString *const OGSceneMetadataClassNameKey = @"ClassName";
NSString *const OGSceneMetadataFileNameKey = @"FileName";
NSString *const OGSceneMetadataTextureAtlasesKey = @"TextureAtlases";
NSString *const OGSceneMetadataDefaultResourcesFileName = @"DefaultLevelResources";

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
                
                NSMutableDictionary *resources = [[NSMutableDictionary alloc] init];
                
                NSString *customResourcesFileName = [configuration objectForKey:OGSceneMetadataCustomResourcesFileNameKey];
                
                if (customResourcesFileName)
                {
                    NSString *pathForCustomResourcesFile = [[NSBundle mainBundle] pathForResource:customResourcesFileName
                                                                                           ofType:OGPropertyFileExtension];
                    
                    if (pathForCustomResourcesFile)
                    {
                        [resources setDictionary:[[NSDictionary alloc] initWithContentsOfFile:pathForCustomResourcesFile]];
                    }
                }
                
                BOOL needLoadDefaultResources = [[configuration objectForKey:OGSceneMetadataNeedLoadDefaultResourcesKey] boolValue];
                
                if (needLoadDefaultResources)
                {
                    NSString *pathForDefaultResourcesFile = [[NSBundle mainBundle] pathForResource:OGSceneMetadataDefaultResourcesFileName
                                                                                            ofType:OGPropertyFileExtension];
                    
                    if (pathForDefaultResourcesFile)
                    {
                        NSDictionary *defaultResources = [[NSDictionary alloc] initWithContentsOfFile:pathForDefaultResourcesFile];
                        
                        for (NSString *resourceKey in defaultResources)
                        {
                            NSDictionary *resourceObj = [defaultResources objectForKey:resourceKey];
                            
                            if ([resources objectForKey:resourceKey])
                            {
                                for (NSString *unitName in resourceObj)
                                {
                                    NSDictionary *unitResources = [resourceObj objectForKey:unitName];
                                    
                                    if ([[resources objectForKey:resourceKey] objectForKey:unitName])
                                    {
                                        for (NSString *resourceName in unitResources)
                                        {
                                            if (!resources[resourceKey][unitName][resourceName])
                                            {
                                                resources[resourceKey][unitName][resourceName] = unitResources[resourceName];
                                            }
                                        }
                                    }
                                    else
                                    {
                                        [[resources objectForKey:resourceKey] setObject:unitResources
                                                                                 forKey:unitName];
                                    }
                                }
                            }
                            else
                            {
                                [resources setObject:resourceObj forKey:resourceKey];
                            }
                        }
                    }
                }
                
                _textureAtlases = [[resources objectForKey:OGSceneMetadataTextureAtlasesKey] copy];
                
                NSArray<NSString *> *loadableClassNames = configuration[OGSceneMetadataLoadableClassesKey];
                NSMutableArray *mutableLoadableClasses = [NSMutableArray array];
                
                if (loadableClassNames)
                {
                    for (NSString *resourceLoadableClassName in loadableClassNames)
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
