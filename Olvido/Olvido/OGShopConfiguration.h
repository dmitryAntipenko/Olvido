//
//  OGShopConfiguration.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OGShopItemConfiguration;

@interface OGShopConfiguration : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong, readonly) NSArray<OGShopItemConfiguration *> *shopItemsConfiguration;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
