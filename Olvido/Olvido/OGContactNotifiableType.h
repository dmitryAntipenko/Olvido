//
//  OGContactNotifiableType.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@protocol OGContactNotifiableType <NSObject>

- (void)contactWithEntityDidBegin:(GKEntity *)entity;

@optional
- (void)contactWithEntityDidEnd:(GKEntity *)entity;

@end
