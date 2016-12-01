//
//  OGAudioLoader.h
//  Olvido
//
//  Created by Алексей Подолян on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGAudioLoader : NSObject

+ (instancetype)sharedInstance;

- (void)loadAudioDataWithUnitname:(NSString *)unitName
                     audioDataKey:(NSString *)audioDataKey
                         fileName:(NSString *)fileName;

- (NSDataAsset *)audioDataWithUnitName:(NSString *)unitName audioDataKey:(NSString *)audioDataKey;

@end
