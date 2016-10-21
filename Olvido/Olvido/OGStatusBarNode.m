//
//  OGStatusBarNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStatusBarNode.h"
#import "OGConstants.h"

NSString *const kOGGameSceneScoreLabelFontName = @"Helvetica";
NSUInteger const kOGGameSceneScoreLabelFontSize = 32;
NSString *const kOGGameSceneDefaultScoreValue = @"0";

@implementation OGStatusBarNode

- (instancetype)init
{
    self = [super initWithImageNamed:kOGStatusBarBackgroundTextureName];
    
    if (self)
    {
        self.alpha = kOGGameSceneStatusBarAlpha;
        self.zPosition = 4;
        
        SKTexture *pauseButtonTexture = [SKTexture textureWithImageNamed:kOGPauseButtonTextureName];
        SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithTexture:pauseButtonTexture];
        
        pauseButton.name = kOGPauseButtonName;
        pauseButton.position = CGPointMake(self.size.width / 2.0 - pauseButton.size.width / 2.0 - kOGGameSceneStatusBarPositionOffset,
                                           0.0);
        
        [self addChild:pauseButton];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:kOGGameSceneScoreLabelFontName];
        scoreLabel.fontSize = kOGGameSceneScoreLabelFontSize;
        scoreLabel.text = kOGGameSceneDefaultScoreValue;
        scoreLabel.position = CGPointMake(0.0, kOGGameSceneScoreLabelYPosition);
        
        self.scoreLabel = scoreLabel;
        [self addChild:scoreLabel];
    }
    
    return self;
}

+ (instancetype)statusBarNode
{
    return [[[OGStatusBarNode alloc] init] autorelease];
}

- (void)dealloc
{
    [_scoreLabel release];
    
    [super dealloc];
}

@end
