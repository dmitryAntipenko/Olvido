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

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSArray<SKTexture *> *> *> *textures;
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

#pragma mark - Atlases managment

+ (void)addAtlasWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName textures:(NSArray<SKTexture *> *)textures;
{
    if (unitName && atlasName &&textures)
    {
        OGTextureManager *instance = [self instance];
        
        dispatch_barrier_sync(instance.syncQueue, ^
                              {
                                  NSMutableDictionary<NSString *, NSArray<SKTexture *> *> *unitAtlases = [instance.textures objectForKey:unitName];
                                  
                                  if (!unitAtlases)
                                  {
                                      unitAtlases = [[NSMutableDictionary alloc] init];
                                      [instance.textures setObject:unitAtlases forKey:unitName];
                                  }
                                  
                                  [unitAtlases setObject:textures forKey:atlasName];
                              });
    }
}

+ (void)purgeAtlasesWithUnitName:(NSString *)unitName
{
    if (unitName)
    {
        OGTextureManager *instance = [self instance];
        
        dispatch_barrier_sync(instance.syncQueue, ^
                              {
                                  [instance.textures removeObjectForKey:unitName];
                              });
    }
}

+ (void)purgeAllTextures
{
    OGTextureManager *instance = [self instance];
    
    dispatch_barrier_sync(instance.syncQueue, ^
                          {
                              [instance.textures removeAllObjects];
                          });
}

+ (BOOL)containsAtlasWithName:(NSString *)atlasName unitName:(NSString *)unitName
{
    __block BOOL result = NO;
    
    if (atlasName && unitName)
    {
        OGTextureManager *instance = [OGTextureManager instance];
        
        dispatch_sync(instance.syncQueue, ^
        {
            result = ([[instance.textures objectForKey:unitName] objectForKey:atlasName] != nil);
        });
    }
    
    return result;
}

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
