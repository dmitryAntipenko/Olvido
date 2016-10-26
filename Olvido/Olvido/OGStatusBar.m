//
//  OGStatusBar.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStatusBar.h"

CGFloat const kOGStatusBarHealthSpriteXOffset = 10.0;
NSUInteger const kOGStatusBarDefaultMaxHealth = 3;
NSString *const kOGStatusBarHealthFullTextureName = @"HealthFull";
NSString *const kOGStatusBarHealthEmptyTextureName = @"HealthEmpty";
NSString *const kOGStatusBarPauseButtonTextureName = @"PauseButton";

@interface OGStatusBar ()

@property (nonatomic, retain) SKTexture *fullHealthTexture;
@property (nonatomic, retain) SKTexture *emptyHealthTexture;

@property (nonatomic, assign) NSUInteger currentHealth;
@property (nonatomic, retain) NSMutableArray<SKSpriteNode *> *healthSprites;

@end

@implementation OGStatusBar

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _healthSprites = [[NSMutableArray alloc] init];
        _fullHealthTexture = [[SKTexture textureWithImageNamed:kOGStatusBarHealthFullTextureName] retain];
        _emptyHealthTexture = [[SKTexture textureWithImageNamed:kOGStatusBarHealthEmptyTextureName] retain];
        
        _maxHealth = kOGStatusBarDefaultMaxHealth;
        _currentHealth = kOGStatusBarDefaultMaxHealth;
    }
    
    return self;
}

- (void)createContents
{
    if (self.maxHealth > 0)
    {
        self.currentHealth = self.maxHealth;
    
        for (NSUInteger i = 0; i < self.maxHealth; i++)
        {
            CGFloat healthSpriteX = (self.fullHealthTexture.size.width + kOGStatusBarHealthSpriteXOffset) * (i + 1);
            CGPoint spritePosition = CGPointMake(-self.statusBarSprite.size.width / 2.0 + healthSpriteX, 0.0);
            [self createHealthSpriteAtPoint:spritePosition];
        }
        
        [self createPauseButton];
    }
}

- (void)createHealthSpriteAtPoint:(CGPoint)point
{
    SKSpriteNode *healthSprite = [SKSpriteNode spriteNodeWithTexture:self.fullHealthTexture];
    
    healthSprite.position = point;
    
    [self.healthSprites addObject:healthSprite];
    [self.statusBarSprite addChild:healthSprite];
}

- (void)createPauseButton
{
    SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithImageNamed:kOGStatusBarPauseButtonTextureName];
    
    CGFloat pauseButtonX = self.statusBarSprite.size.width / 2.0 - pauseButton.size.width;
    CGPoint pauseButtonPosition = CGPointMake(pauseButtonX, 0.0);
    pauseButton.position = pauseButtonPosition;
    
    [self.statusBarSprite addChild:pauseButton];
}

- (void)dealloc
{
    [_healthSprites release];
    [_fullHealthTexture release];
    [_emptyHealthTexture release];
    
    [super dealloc];
}

@end
