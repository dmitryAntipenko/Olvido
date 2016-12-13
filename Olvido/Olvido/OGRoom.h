//
//  OGRoom.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGRoom : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong) SKNode *roomNode;

@property (nonatomic, assign, getter=isNeedsFlashlight) BOOL needsFlashlight;

@property (nonatomic, strong, readonly) NSArray<GKGraph *> *enemiesGraphs;

- (instancetype)initWithNode:(SKNode *)node;

- (void)addGradient;

@end
