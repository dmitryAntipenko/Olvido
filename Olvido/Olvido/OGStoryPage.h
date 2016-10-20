//
//  OGStoryPage.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGStoryPage : NSObject

//@property ()
@property (nonatomic, copy, readonly) NSArray<NSString *> *replicas;

- (void)addReplica:(NSString *)replica;
- (void)removeReplica:(NSString *)replica;

@end
