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
    
    [self createEnemiesWithStartPoint:CGPointMake(200, 400)];
    
}

- (void)createEnemiesWithStartPoint:(CGPoint)point
{
    for (int i = 0; i < 5; i++)
    {
        OGEnemy *enemy = [OGEnemy enemy];
        enemy.position = point;
        [self addChild:enemy];
        
        CGVector vector = ogRanomVector(kOGEnemyVelocity);
        
        [enemy.physicsBody applyImpulse:vector];
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
