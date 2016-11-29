//
//  OGLoadTexturesOperation.h
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGLoadTexturesOperation : NSOperation

+ (instancetype)loadTexturesOperationWithUnitName:(NSString *)unitName
                                         atlasKey:(NSString *)atlasKey
                                        atlasName:(NSString *)atlasname;

@end
