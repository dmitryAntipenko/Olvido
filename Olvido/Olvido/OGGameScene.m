//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGEnemy.h"

@interface OGGameScene ()

@property (nonatomic, retain) SKSpriteNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    self.background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
    self.background.size = self.frame.size;
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.background];
    
    [self createEnemies];
    
}

- (void)createEnemies
{
    for (int i = 0; i < 5; i++)
    {
        OGEnemy *enemy = [OGEnemy enemy];
        enemy.position = ogRanomPoint(enemy.size.width,
                                      self.size.width - enemy.size.width,
                                      enemy.size.width,
                                      self.size.height - enemy.size.width);
        [self addChild:enemy];
        
        [enemy.physicsBody applyImpulse:ogRanomVector(kOGEnemyVelocity)];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touched");
}

-(void)update:(CFTimeInterval)currentTime
{
    
}

@end
