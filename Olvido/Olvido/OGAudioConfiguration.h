//
//  OGAudioConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGAudioConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *audioName;
@property (nonatomic, assign, readonly) BOOL repeatForever;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
