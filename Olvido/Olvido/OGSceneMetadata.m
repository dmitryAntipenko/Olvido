//
//  OGSceneMetadata.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneMetadata.h"

NSString *const kOGSceneMetadataOnDemandResourcesKey = @"OnDemandResources";
NSString *const kOGSceneMetadataClassNameKey = @"ClassName";
NSString *const kOGSceneMetadataFileNameKey = @"FileName";

@implementation OGSceneMetadata

- (instancetype)initWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;
{
    if (configuration)
    {
        self = [self init];
        
        if (self)
        {
            NSString *className = [configuration objectForKey:kOGSceneMetadataClassNameKey];
            NSString *fileName = [configuration objectForKey:kOGSceneMetadataFileNameKey];
            
            if (className && fileName)
            {
                _sceneClass = NSClassFromString(className);
                _fileName = fileName;
                _identifier = identifier;
                
                NSArray<NSString *> *onDemandResourcesClassesNames = [configuration objectForKey:kOGSceneMetadataOnDemandResourcesKey];
                
                NSMutableArray *mutableLoadableClasses = [NSMutableArray array];
                
                if (onDemandResourcesClassesNames)
                {
                    for (NSString *resourceLoadableClassName in onDemandResourcesClassesNames)
                    {
                        Class loadableClass = NSClassFromString(resourceLoadableClassName);
                        
                        if ([loadableClass conformsToProtocol:@protocol(OGResourceLoadable)])
                        {
                            [mutableLoadableClasses addObject:loadableClass];
                        }
                    }
                }
                
                _loadableClasses = [mutableLoadableClasses copy];
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
