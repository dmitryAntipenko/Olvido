//
//  OGEntityAdding.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@protocol OGEntityManaging <NSObject>

- (void)addEntity:(GKEntity *)entity;
- (void)removeEntity:(GKEntity *)entity;

@end
