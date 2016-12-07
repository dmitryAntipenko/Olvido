//
//  OGShopConfiguration.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGEntityConfiguration;

@interface OGShopItemConfiguration : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) SKTexture *texture;
@property (nonatomic, assign) Class unitClass;
@property (nonatomic, assign) Class unitConfigurationClass;

@property (nonatomic, strong) OGEntityConfiguration *unitConfiguration;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
