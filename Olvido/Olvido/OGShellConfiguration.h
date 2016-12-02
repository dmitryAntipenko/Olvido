//
//  OGShellConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGShellConfiguration : NSObject

@property (nonatomic, assign, readonly) NSInteger damage;
@property (nonatomic, assign, readonly) NSInteger speed;
@property (nonatomic, copy, readonly) NSString *textureName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
