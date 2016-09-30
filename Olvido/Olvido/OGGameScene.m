//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGEnemy.h"

NSString *const kOGGameSceneBackgroundSpriteName = @"Background";

@interface OGGameScene ()

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor backgroundLightGrayColor];
    
    [self createSceneContents];
}

- (void)createSceneContents
{
    CGRect borderEdgesRect = CGRectMake(self.frame.origin.x + kOGGameSceneBorderSize,
                                        self.frame.origin.y + kOGGameSceneBorderSize,
                                        self.frame.size.width - kOGGameSceneBorderSize,
                                        self.frame.size.height - kOGGameSceneBorderSize);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderEdgesRect];
    
    self.background = [self createBackground];
    [self addChild:self.background];
    
    self.foreground = [self createForeground];
    [self addChild:self.foreground];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touched");
}

-(void)update:(CFTimeInterval)currentTime
{
    
}

@end
