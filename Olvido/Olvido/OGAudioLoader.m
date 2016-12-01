//
//  OGAudioLoader.m
//  Olvido
//
//  Created by Алексей Подолян on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAudioLoader.h"

char *const kOGAudioLoaderSyncQueueLabel = "com.zeouniversity.olvido.audioLoaderSyncQueue";

@interface OGAudioLoader ()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableDictionary *data;

@end

@implementation OGAudioLoader

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _data = [[NSMutableDictionary alloc] init];
        _syncQueue = dispatch_queue_create(kOGAudioLoaderSyncQueueLabel, DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static OGAudioLoader *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        instance = [[OGAudioLoader alloc] init];
    });
    
    return instance;
}

- (void)loadAudioDataWithUnitname:(NSString *)unitName
                     audioDataKey:(NSString *)audioDataKey
                         fileName:(NSString *)fileName
{
    if (unitName && audioDataKey && fileName)
    {
        
    }
}

- (NSDataAsset *)audioDataWithUnitName:(NSString *)unitName audioDataKey:(NSString *)audioDataKey;
{
    return nil;
}

@end
