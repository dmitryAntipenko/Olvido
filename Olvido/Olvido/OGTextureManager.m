//
//  OGTextureManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureManager.h"

char *const kOGTextureManagerQueueLabel = "com.zeouniversity.olvido.textureManagerSyncQueue";

@interface OGTextureManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary<NSString *, NSArray<SKTexture *> *> *> *textures;
@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end

@implementation OGTextureManager

+ (instancetype)instance
{
    static OGTextureManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        instance = [[OGTextureManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textures = [[NSMutableDictionary alloc] init];
        _syncQueue = dispatch_queue_create(kOGTextureManagerQueueLabel, DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

#pragma mark - Memory managment

//+ (void)loadAtlasWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName completion:(void (^)())completion;
//{
//    dispatch_queue_t currentQueue = [NSOperationQueue currentQueue].underlyingQueue;
//    
//    dispatch_barrier_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
//    
//    dispatch_barrier_async(self.syncQueue, ^
//    {
//        if (unitName && atlasName)
//        {
//            NSMutableDictionary *atlases = [[self.textures objectForKey:unitName] mutableCopy];
//            
//            if (!atlases)
//            {
//                atlases = [[NSMutableDictionary alloc] init];
//            }
//            
//            SKTextureAtlas *atlas = [atlases objectForKey:atlasName];
//            
//            if (!atlas)
//            {
//                atlas = [SKTextureAtlas atlasNamed:atlasName];
//                
//                NSMutableArray *atlasTextures = [[NSMutableArray alloc] init];
//                
//                for (NSString *textureName in atlas.textureNames)
//                {
//                    [atlasTextures addObject:[atlas textureNamed:textureName]];
//                }
//                
//                [atlases setObject:atlasTextures forKey:atlasName];
//            }
//            
//            
//            [atlas preloadWithCompletionHandler:^{}];
//            
//            [self.textures setObject:[atlases copy] forKey:atlasName];
//        }
//        
//        dispatch_async(currentQueue, completion);
//    });
//}
//
//+ (void)purgeAtlasesWithUnitName:(NSString *)unitName
//{
//    if (unitName)
//    {
//        [self.textures removeObjectForKey:unitName];
//    }
//}

#pragma mark - Accessing to atlases

+ (NSDictionary<NSString *, NSArray *> *)atlasesWithUnitName:(NSString *)unitName;
{
    OGTextureManager *instance = [self instance];
    
    __block NSDictionary<NSString *, NSArray *> *result = nil;
    
    dispatch_sync(instance.syncQueue, ^
    {
        if (unitName)
        {
            result = [instance.textures objectForKey:unitName];
        }
    });
    
    return result;
}

@end
