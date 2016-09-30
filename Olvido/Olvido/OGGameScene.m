//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGPlayer.h"

NSString *const kOGGameScenePlayerImageName = @"Player Ball";

@interface OGGameScene ()

@property (nonatomic, retain) SKSpriteNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@property (nonatomic, assign) OGPlayer *player;
@property (getter=isPlayerCaptured) BOOL playerCapture;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    self.background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    
    self.background.size = self.frame.size;
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.background];
    
    self.player = [OGPlayer palyerWithTexture:[SKTexture textureWithImageNamed:kOGGameScenePlayerImageName]];
    
    if (self.player)
    {
        [self addChild:self.player];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:kOGPlayerPlayerName] && (powf((location.x - touchedNode.position.x), 2) + powf((location.y - touchedNode.position.y), 2) < powf(kOGPlayerPlayerRadius, 2)))
    {
        self.playerCapture = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (self.isPlayerCaptured)
    {
        self.player.position = location;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPlayerCaptured)
    {
        self.playerCapture = NO;
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    
}

@end
