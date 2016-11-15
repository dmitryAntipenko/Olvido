//
//  OGInventoryElement.h
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGInventoryItem <NSObject>

@property (nonatomic, strong, readonly) SKTexture *texture;
@property (nonatomic, strong, readonly) NSString *identifier;

- (SKTexture *)texture;
- (NSString *)identifier;

@optional
- (void)didTaken;
- (void)didThrown;

@end
