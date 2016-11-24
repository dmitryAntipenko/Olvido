//
//  OGTextureManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureAtlasesManager.h"

char *const kOGTextureManagerQueueLabel = "com.zeouniversity.olvido.textureManagerSyncQueue";

@interface OGTextureAtlasesManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, SKTextureAtlas *> *> *textures;
@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end

@implementation OGTextureAtlasesManager

+ (instancetype)sharedInstance;
{
    static OGTextureAtlasesManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      instance = [[OGTextureAtlasesManager alloc] init];
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

- (void)addAtlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey atlas:(SKTextureAtlas *)atlas
{
    if (unitName && atlasKey && atlas)
    {
        dispatch_barrier_sync(self.syncQueue, ^
          {
              NSMutableDictionary<NSString *, SKTextureAtlas *> *unitAtlases = [self.textures objectForKey:unitName];
              
              if (!unitAtlases)
              {
                  unitAtlases = [[NSMutableDictionary alloc] init];
                  [self.textures setObject:unitAtlases forKey:unitName];
              }
              
              [unitAtlases setObject:atlas forKey:atlasKey];
          });
    }
}

- (void)purgeAtlasesWithUnitName:(NSString *)unitName
{
    if (unitName)
    {
        dispatch_barrier_sync(self.syncQueue, ^
          {
              [self.textures removeObjectForKey:unitName];
          });
    }
}

- (void)purgeAllTextures
{
    dispatch_barrier_sync(self.syncQueue, ^
      {
          [self.textures removeAllObjects];
      });
}

- (BOOL)containsAtlasWithKey:(NSString *)atlasKey unitName:(NSString *)unitName
{
    __block BOOL result = NO;
    
    if (atlasKey && unitName)
    {
        dispatch_sync(self.syncQueue, ^
        {
            result = ([[self.textures objectForKey:unitName] objectForKey:atlasKey] != nil);
        });
    }
    
    return result;
}

#pragma mark - Accessing to atlases

- (NSDictionary<NSString *, SKTextureAtlas *> *)atlasesWithUnitName:(NSString *)unitName
{
    __block NSDictionary<NSString *, SKTextureAtlas *> *result = nil;
    
    dispatch_sync(self.syncQueue, ^
      {
          if (unitName)
          {
              result = [self.textures objectForKey:unitName];
          }
      });
    
    return result;
}

@end
