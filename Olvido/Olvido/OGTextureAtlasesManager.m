//
//  OGTextureManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureAtlasesManager.h"

char *const kOGTextureManagerQueueLabel = "com.zeouniversity.olvido.textureManagerSyncQueue";

@protocol OGTextureAtlasesManagerPairDelegate <NSObject>

- (void)pairReletadScenesCountDidSetToZero:(OGTextureAtlasesManagerPair *)pair;

@end

@interface OGTextureAtlasesManagerPair : NSObject

@property (nonatomic, strong) NSString *atlasKey;
@property (nonatomic, weak)   NSMutableDictionary *unitDictionary;
@property (nonatomic, strong) SKTextureAtlas *textureAtlas;
@property (nonatomic, assign) NSUInteger relatedScenesCount;
@property (nonatomic, weak)   id <OGTextureAtlasesManagerPairDelegate> delegate;

- (instancetype)initWithTextureAtlas:(SKTextureAtlas *)textureAtlas;
- (void)increment;
- (void)decrement;

@end

@implementation OGTextureAtlasesManagerPair

- (instancetype)initWithTextureAtlas:(nonnull SKTextureAtlas *)textureAtlas
{
    self = [self init];
    
    if (self)
    {
        _relatedScenesCount = 1;
        _textureAtlas = textureAtlas;
    }
    
    return self;
}

- (void)increment
{
    self.relatedScenesCount++;
}

- (void)decrement
{
    self.relatedScenesCount--;
    
    if (self.relatedScenesCount <= 0)
    {
        [self.delegate pairReletadScenesCountDidSetToZero:self];
    }
}

@end



@interface OGTextureAtlasesManager () <OGTextureAtlasesManagerPairDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, OGTextureAtlasesManagerPair *> *> *textures;
@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end

@implementation OGTextureAtlasesManager

+ (instancetype)sharedInstance;
{
    static OGTextureAtlasesManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^()
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
        dispatch_barrier_sync(self.syncQueue, ^()
                              {
                                  NSMutableDictionary<NSString *, OGTextureAtlasesManagerPair *> *unitAtlases = self.textures[unitName];
                                  
                                  if (!unitAtlases)
                                  {
                                      unitAtlases = [[NSMutableDictionary alloc] init];
                                      self.textures[unitName] = unitAtlases;
                                  }
                                  
                                  OGTextureAtlasesManagerPair *pair = unitAtlases[atlasKey];
                                  
                                  if (pair)
                                  {
                                      [pair increment];
                                  }
                                  else
                                  {
                                      OGTextureAtlasesManagerPair *newPair = [[OGTextureAtlasesManagerPair alloc] initWithTextureAtlas:atlas];
                                      unitAtlases[atlasKey] = newPair;
                                      newPair.unitDictionary = unitAtlases;
                                      newPair.atlasKey = atlasKey;
                                      newPair.delegate = self;
                                  }
                              });
    }
}

- (void)addOrReplaceAtlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey atlas:(SKTextureAtlas *)atlas
{
    if (unitName && atlasKey && atlas)
    {
        dispatch_barrier_sync(self.syncQueue, ^()
                              {
                                  NSMutableDictionary<NSString *, OGTextureAtlasesManagerPair *> *unitAtlases = self.textures[unitName];
                                  
                                  if (!unitAtlases)
                                  {
                                      unitAtlases = [[NSMutableDictionary alloc] init];
                                      self.textures[unitName] = unitAtlases;
                                  }
                                  
                                  OGTextureAtlasesManagerPair *newPair = [[OGTextureAtlasesManagerPair alloc] initWithTextureAtlas:atlas];
                                  unitAtlases[atlasKey] = newPair;
                                  newPair.unitDictionary = unitAtlases;
                                  newPair.atlasKey = atlasKey;
                                  newPair.delegate = self;
                              });
    }
}

- (void)purgeAtlasesWithUnitName:(NSString *)unitName
{
    if (unitName)
    {
        dispatch_barrier_sync(self.syncQueue, ^()
                              {
                                  NSDictionary<NSString *, OGTextureAtlasesManagerPair *> *unitAtlases = self.textures[unitName];
                                  
                                  if (unitAtlases)
                                  {
                                      for (OGTextureAtlasesManagerPair *pair in unitAtlases)
                                      {
                                          [pair decrement];
                                          
                                          if (pair)
                                      }
                                  }
                              });
    }
}

- (void)purgeAllTextures
{
    dispatch_barrier_sync(self.syncQueue, ^()
                          {
                              [self.textures removeAllObjects];
                          });
}

- (BOOL)containsAtlasWithKey:(NSString *)atlasKey unitName:(NSString *)unitName
{
    __block BOOL result = NO;
    
    if (atlasKey && unitName)
    {
        dispatch_sync(self.syncQueue, ^()
                      {
                          result = (self.textures[unitName][atlasKey] != nil);
                      });
    }
    
    return result;
}

#pragma mark - Accessing to atlases

- (NSDictionary<NSString *, SKTextureAtlas *> *)atlasesWithUnitName:(NSString *)unitName
{
    __block NSDictionary<NSString *, SKTextureAtlas *> *result = nil;
    
    dispatch_sync(self.syncQueue, ^()
                  {
                      if (unitName)
                      {
                          result = self.textures[unitName];
                      }
                  });
    
    return result;
}

- (SKTextureAtlas *)atlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey
{
    __block SKTextureAtlas *result = nil;
    
    dispatch_sync(self.syncQueue, ^()
                  {
                      if (unitName && atlasKey)
                      {
                          NSDictionary<NSString *, SKTextureAtlas *> *unitAtlases = self.textures[unitName];
                          
                          if (unitAtlases)
                          {
                              result = unitAtlases[atlasKey];
                          }
                      }
                  });
    
    return result;
}

#pragma mark - OGTextureAtlasesManagerPairDelegate

- (void)pairReletadScenesCountDidSetToZero:(OGTextureAtlasesManagerPair *)pair
{
    pair.textureAtlas = nil;
    [pair.unitDictionary removeObjectForKey:pair.atlasKey];
}

@end
