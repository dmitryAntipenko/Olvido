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

NSInteger const kOGStoriesLevelControllerActionDefaultDuration = 0;
NSString *const kOGStoriesLevelControllerActionParameterReplica = @"Replica";
NSString *const kOGStoriesLevelControllerActionParameterReplicaText = @"Text";

NSString *const kOGStoriesLevelControllerActionParameterReplicaSpeechCloudImageName = @"SpeechCloudImageName";
NSString *const kOGStoriesLevelControllerActionParameterReplicaSpeechCloudNodeName = @"cloudName";

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

- (void)prepareStoryWithPlistName:(NSString *)plistName view:(SKView *)view
{
    [self.sceneStory removeAllObjects];
    
    OGStoryLevelScene *storyLevelScene = [[OGStoryLevelScene alloc] initWithSize:view.scene.size];
    
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
            
            [storyLevelScene addPerformer:performer];
            [performers addObject:performer];
        }];
        
        self.sceneStory[kOGStoriesLevelControllerPerformers] = performers;
        
        NSArray *allActions = plistDate[kOGStoriesLevelControllerActions];
        
        [self parseStepWithActionsArray:allActions];
    }
    
    self.currentScene = storyLevelScene;
    
    [storyLevelScene release];
    
    [self runStoryWithView:view];
}

- (void)parseStepWithActionsArray:(NSArray *)actionsArray
{
    NSMutableArray *actions = [NSMutableArray array];
    
    for (NSDictionary *step in actionsArray)
    {
        NSMutableDictionary *actionStep = [NSMutableDictionary dictionary];
        
        [step enumerateKeysAndObjectsUsingBlock:^(NSString *perfomerName, NSDictionary *performerActions, BOOL *stop)
         {
             actionStep[perfomerName] = [self parseActionsWithActionsDictionary:performerActions];
         }];
        
        [actions addObject:actionStep];
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
    SKAction *action = nil;
    
    if (dictionary[kOGStoriesLevelControllerActionParameterPosition])
    {
        CGFloat x = [dictionary[kOGStoriesLevelControllerActionParameterPosition][kOGStoriesLevelControllerActionParameterPositionX] floatValue];
        CGFloat y = [dictionary[kOGStoriesLevelControllerActionParameterPosition][kOGStoriesLevelControllerActionParameterPositionY] floatValue];
        
        CGPoint position = CGPointMake(x, y);
        
        action = [SKAction customActionWithDuration:kOGStoriesLevelControllerActionDefaultDuration actionBlock:^(SKNode *node, CGFloat elapsedTime)
        {
            node.position = position;
            ((SKSpriteNode *)node).size = ((SKSpriteNode *)node).texture.size;
        }];
    }
    
    return action;
}


- (SKAction *)actionSayWithDictionary:(NSDictionary *)dictionary
{
    SKAction *action = nil;
    
    if (dictionary[kOGStoriesLevelControllerActionParameterReplica]
        && dictionary[kOGStoriesLevelControllerActionParameterReplicaSpeechCloudImageName])
    {
        NSString *replica = dictionary[kOGStoriesLevelControllerActionParameterReplica][kOGStoriesLevelControllerActionParameterReplicaText];
        NSString *cloudImageName = dictionary[kOGStoriesLevelControllerActionParameterReplicaSpeechCloudImageName];
        
        SKSpriteNode *cloudNode = [SKSpriteNode spriteNodeWithImageNamed:cloudImageName];
        cloudNode.name = kOGStoriesLevelControllerActionParameterReplicaSpeechCloudNodeName;
        
        cloudNode.position = CGPointMake(400, 50);
        
        SKLabelNode *replicaNode = [SKLabelNode labelNodeWithText:replica];
        replicaNode.fontColor = [SKColor blackColor];
        replicaNode.position = CGPointZero;
        replicaNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        replicaNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [cloudNode addChild:replicaNode];
        
        SKAction *createCloud = [SKAction customActionWithDuration:kOGStoriesLevelControllerActionDefaultDuration actionBlock:^(SKNode *node, CGFloat elapsedTime)
        {
            [node.parent addChild:cloudNode];
        }];
        
        SKAction *durationCloud = [SKAction waitForDuration:3];
        
        SKAction *removeCloud = [SKAction customActionWithDuration:kOGStoriesLevelControllerActionDefaultDuration actionBlock:^(SKNode *node, CGFloat elapsedTime)
        {
            [cloudNode removeFromParent];
        }];
        
        action = [SKAction sequence:@[createCloud, durationCloud, removeCloud]];
        
    }
    
    return action;
}

- (void)runStoryWithView:(SKView *)view
{
    [view presentScene:self.currentScene];
    [self.currentScene runStoryWithSceneStory:self.sceneStory];
}

@end
