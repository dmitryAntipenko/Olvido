//
//  OGShopConfiguration.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGShopItemConfiguration : NSObject

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) SKTexture *texture;
@property (nonatomic, assign) Class unitClass;
@property (nonatomic, assign) Class unitConfigurationClass;

@property (nonatomic, strong) id *unitConfiguration;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
