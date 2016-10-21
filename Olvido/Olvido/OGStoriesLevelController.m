//
//  OGStoriesLevelController.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoriesLevelController.h"
#import "OGStoryLevelScene.h"

NSString *const kOGStoriesLevelControllerStoriesExtension = @"plist";

NSString *const kOGStoriesLevelControllerActions = @"Actions";
NSString *const kOGStoriesLevelControllerPerformers = @"Performers";

NSString *const kOGStoriesLevelControllerPerformerPropertyImageNameKey = @"ImageName";

NSString *const kOGStoriesLevelControllerActionCreate = @"Create";
NSString *const kOGStoriesLevelControllerActionSay = @"Say";

NSString *const kOGStoriesLevelControllerActionParameterPosition = @"Position";
NSString *const kOGStoriesLevelControllerActionParameterPositionX = @"X";
NSString *const kOGStoriesLevelControllerActionParameterPositionY = @"Y";

NSInteger const kOGStoriesLevelControllerActionDefaultDuration = 0.0;
NSString *const kOGStoriesLevelControllerActionParameterReplica = @"Replica";
NSString *const kOGStoriesLevelControllerActionParameterReplicaText = @"Text";

@interface OGStoriesLevelController ()

@property (nonatomic, retain) OGStoryLevelScene *currentScene;
@property (nonatomic, retain) NSMutableDictionary *sceneStory;
@end

@implementation OGStoriesLevelController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _sceneStory = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_sceneStory release];
    [_currentScene release];
    
    [super dealloc];
}


- (void)prepareStoryWithPlistName:(NSString *)plistName
{
    [self.sceneStory removeAllObjects];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName
                                                          ofType:kOGStoriesLevelControllerStoriesExtension];
    NSDictionary *plistDate = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (plistDate)
    {
        NSMutableArray<SKSpriteNode *> *performers = [NSMutableArray array];
        NSDictionary *performersData = plistDate[kOGStoriesLevelControllerPerformers];
        
        [performersData enumerateKeysAndObjectsUsingBlock:^(NSString *performerName, NSDictionary *performerData, BOOL *stop)
        {
            SKSpriteNode *performer = [SKSpriteNode node];
            performer.name = performerName;
            
            for (NSString *performerPropertyKey in performersData[performerName])
            {
                if ([performerPropertyKey isEqualToString:kOGStoriesLevelControllerPerformerPropertyImageNameKey])
                {
                    performer.texture = [SKTexture textureWithImageNamed:performersData[performerName][performerPropertyKey]];
                }
            }
            
            [performers addObject:performer];
        }];
        
        self.sceneStory[kOGStoriesLevelControllerPerformers] = performers;
        
        NSArray *allActions = plistDate[kOGStoriesLevelControllerActions];
        
        [self parseStepWithActionsArray:allActions];
    }
    
    OGStoryLevelScene *storyLevelScene = [[OGStoryLevelScene alloc] init];
    
    self.currentScene = storyLevelScene;
    
    [storyLevelScene release];
    
    [self runStory];
}

- (void)parseStepWithActionsArray:(NSArray *)actionsArray
{
    NSMutableDictionary *actions = [NSMutableDictionary dictionary];
    
    for (NSDictionary *step in actionsArray)
    {
        [step enumerateKeysAndObjectsUsingBlock:^(NSString *perfomerName, NSDictionary *performerActions, BOOL *stop)
         {
             if (![actions objectForKey:perfomerName])
             {
                 [actions setObject:[NSMutableArray array] forKey:perfomerName];
             }
             
             [actions[perfomerName] addObject:[self parseActionsWithActionsDictionary:performerActions]];
         }];
    }
    
    self.sceneStory[kOGStoriesLevelControllerActions] = actions;
}

- (NSArray *)parseActionsWithActionsDictionary:(NSDictionary *)actionsDictionary
{
    __block NSMutableArray *result = [NSMutableArray array];
    
    [actionsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *actionName, NSDictionary *actionParameters, BOOL *stop)
    {
        if ([actionName isEqualToString:kOGStoriesLevelControllerActionCreate])
        {
            SKAction *createAction = [self actionCreateWithDictionary:actionParameters];
            [result addObject:[[createAction copy] autorelease]];
        }
        else if ([actionName isEqualToString:kOGStoriesLevelControllerActionSay])
        {
            SKAction *sayAction = [self actionSayWithDictionary:actionParameters];
            [result addObject:[[sayAction copy] autorelease]];
        }
    }];
    
    return result;
}

- (SKAction *)actionCreateWithDictionary:(NSDictionary *)dictionary
{
    __block SKAction *action = nil;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *actionParameterName, NSDictionary *parameterValue, BOOL *stop)
     {
         if ([actionParameterName isEqualToString:kOGStoriesLevelControllerActionParameterPosition])
         {
             CGFloat x = [parameterValue[kOGStoriesLevelControllerActionParameterPositionX] floatValue];
             CGFloat y = [parameterValue[kOGStoriesLevelControllerActionParameterPositionY] floatValue];
             
             CGPoint position = CGPointMake(x, y);
             
             action = [SKAction customActionWithDuration:kOGStoriesLevelControllerActionDefaultDuration actionBlock:^(SKNode *node, CGFloat elapsedTime)
             {
                 node.position = position;
                 node.hidden = NO;
             }];
         }
        
     }];
    
    return action;
}


- (SKAction *)actionSayWithDictionary:(NSDictionary *)dictionary
{
    __block SKAction *action = nil;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *actionParameterName, NSDictionary *parameterValue, BOOL *stop)
     {
         if ([actionParameterName isEqualToString:kOGStoriesLevelControllerActionParameterReplica])
         {
             NSString *replica = parameterValue[kOGStoriesLevelControllerActionParameterReplica][kOGStoriesLevelControllerActionParameterReplicaText];
             
             action = [SKAction customActionWithDuration:kOGStoriesLevelControllerActionDefaultDuration actionBlock:^(SKNode *node, CGFloat elapsedTime)
             {
                 NSLog(@"%@", replica);
             }];
         }
     }];
    
    return action;
}

- (void)runStory
{
    [self.currentScene runStoryWithSceneStory:self.sceneStory];
}

@end
