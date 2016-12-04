//
//  OGDoorConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGEntityConfiguration.h"

@interface OGDoorConfiguration : OGEntityConfiguration

@property (nonatomic, copy, readonly) NSString *destination;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, assign, readonly) BOOL isLocked;
@property (nonatomic, assign, readonly) CGFloat openDistance;
@property (nonatomic, strong, readonly) NSArray<NSString *> *keys;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
