//
//  OGRoom.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGRoom.h"
#import "SKTexture+Gradient.h"
#import "OGZPositionEnum.h"

@interface OGRoom ()

@property (nonatomic, strong) NSMutableArray<GKGraph *> *mutableEnemiesGraphs;

@end

@implementation OGRoom

- (instancetype)initWithNode:(SKNode *)node
{
    self = [super init];
    
    if (self)
    {
        _roomNode = node;
        
        _mutableEnemiesGraphs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addGradient
{
    CGSize size = [self.roomNode calculateAccumulatedFrame].size;
    
    SKTexture *gradientTexture = [SKTexture textureWithVerticalGradientOfSize:size
                                                                topRightColor:[CIColor clearColor]
                                                              bottomLeftColor:[CIColor blackColor]];
    
    SKSpriteNode *gradientNode = [SKSpriteNode spriteNodeWithTexture:gradientTexture
                                                                size:size];
    gradientNode.zPosition = OGZPositionCategoryForeground;
    gradientNode.alpha = 0.5;
    
    [self.roomNode addChild:gradientNode];
}

#pragma mark - accessors

- (NSArray<GKGraph *> *)enemiesGraphs
{
    return self.mutableEnemiesGraphs;
}

- (NSString *)identifier
{
    return self.roomNode.name;
}


@end
