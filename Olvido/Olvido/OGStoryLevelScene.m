//
//  OGStoryLevelScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryLevelScene.h"

NSString *const kOGStoryLevelSceneActions = @"Actions";
NSString *const kOGStoryLevelScenePerformers = @"Performers";

@interface OGStoryLevelScene ()

@property (nonatomic, copy) NSMutableArray<SKSpriteNode *> *mutablePerformers;
@property (nonatomic, retain) SKNode *rootNode;
@property (nonatomic, retain) NSMutableDictionary *sceneStory;
@property (nonatomic, assign, getter=isRunned) BOOL run;
@end

@implementation OGStoryLevelScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _mutablePerformers = [[NSMutableArray alloc] init];
        _sceneStory = [[NSMutableDictionary alloc] init];
        _rootNode = [[SKNode alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_mutablePerformers release];
    [_rootNode release];
    [_sceneStory release];
    
    [super dealloc];
}

- (void)runStoryWithSceneStory:(NSMutableDictionary *)sceneStory
{
    [self setBackgroundColor:[SKColor blackColor]];
    [self addChild:self.rootNode];
    
    self.run = YES;
    
    self.sceneStory = sceneStory;
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.isRunned && [self stepEnd] && ((NSArray *)self.sceneStory[kOGStoryLevelSceneActions]).count > 0)
    {
        [self.sceneStory[kOGStoryLevelSceneActions][0] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *actions, BOOL *stop)
        {
            SKSpriteNode *node = nil;
            
            for (SKSpriteNode *spriteNode in self.mutablePerformers)
            {
                if ([spriteNode.name isEqualToString:key])
                {
                    node = spriteNode;
                    break;
                }
            }

            SKAction *action = [SKAction sequence:actions];
            [node runAction:action];
        }];
        
        [self.sceneStory[kOGStoryLevelSceneActions] removeObjectAtIndex:0];
    }
}

- (BOOL)stepEnd
{
    __block BOOL check = YES;
    
    [self.performers enumerateObjectsUsingBlock:^(SKSpriteNode *performer, NSUInteger idx, BOOL *stop)
    {
        if (performer.hasActions)
        {
            check = NO;
        }
    }];
    
    return check;
}

- (NSArray<SKSpriteNode *> *)performers
{
    return (NSArray *)self.mutablePerformers;
}

- (void)addPerformer:(SKSpriteNode *)performer
{
    if (![self.mutablePerformers containsObject:performer])
    {
        [self.mutablePerformers addObject:performer];
        [self.rootNode addChild:performer];
    }
}

- (void)removePerformer:(SKSpriteNode *)performer
{
    if ([self.mutablePerformers containsObject:performer])
    {
        [performer removeFromParent];
        [self.mutablePerformers removeObject:performer];
    }
}

@end
