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
@interface OGStoriesLevelController ()

@property (nonatomic, retain) OGStoryLevelScene *currentScene;

@end

@implementation OGStoriesLevelController

- (void)prepareStoryWithPlistName:(NSString *)plistName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName
                                                          ofType:kOGStoriesLevelControllerStoriesExtension];
    NSDictionary *plistDate = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (plistDate)
    {
        NSMutableArray<SKSpriteNode *> *perfomers = [NSMutableArray array];
        NSDictionary *performersData = plistDate[kOGStoriesLevelControllerPerformers];
        
        [performersData enumerateKeysAndObjectsUsingBlock:^(NSString *performerName, NSDictionary *performerData, BOOL *stop)
        {
            for (NSString *performerKey in performersData.allKeys)
            {
                SKSpriteNode *performer = [SKSpriteNode node];
                performer.name = performerKey;
                
                for (NSString *performerPropertyKey in performersData[performerKey])
                {
                    if ([performerPropertyKey isEqualToString:kOGStoriesLevelControllerPerformerPropertyImageNameKey])
                    {
                        performer.texture = [SKTexture textureWithImageNamed:performersData[performerKey][performerPropertyKey]];
                    }
                }
                
                [perfomers addObject:performer];
            }
        }];
        
        NSArray *allActions = plistDate[kOGStoriesLevelControllerActions];
        for (NSDictionary *step in allActions)
        {
            [step enumerateKeysAndObjectsUsingBlock:^(NSString *perfomerName, NSDictionary *actions, BOOL *stop)
            {
                
                
                
                
                NSLog(@"%@", actions);
            }];
        }
    }
}

- (void)runStory
{
    
}


@end
