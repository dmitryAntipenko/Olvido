//
//  OGStatusBar.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStatusBar.h"
#import "OGHealthComponent.h"

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
        
        _currentHealth = kOGStatusBarDefaultMaxHealth;
    }
    
    return self;
}

- (void)setHealthComponent:(OGHealthComponent *)healthComponent
{
    _healthComponent = healthComponent;
    
    self.currentHealth = healthComponent.currentHealth;
}

- (void)createContents
{
    if (self.healthComponent)
    {
        for (NSUInteger i = 0; i < self.healthComponent.maxHealth; i++)
        {
            SKSpriteNode *healthSprite = [SKSpriteNode node];
            
            CGFloat healthSpriteX = (self.fullHealthTexture.size.width + kOGStatusBarHealthSpriteXOffset) * (i + 1);
            CGPoint spritePosition = CGPointMake(-self.statusBarSprite.size.width / 2.0 + healthSpriteX, 0.0);
            
            healthSprite.position = spritePosition;
            healthSprite.zPosition = self.statusBarSprite.zPosition + 1.0;
            healthSprite.texture = (i < self.healthComponent.currentHealth) ? self.fullHealthTexture : self.emptyHealthTexture;
            
            [self.healthSprites addObject:healthSprite];
            [self.statusBarSprite addChild:healthSprite];
        }
    }
    
    [self createPauseButton];
}

- (void)createPauseButton
{
    SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithImageNamed:kOGStatusBarPauseButtonTextureName];
    
    CGFloat pauseButtonX = self.statusBarSprite.size.width / 2.0 - pauseButton.size.width;
    CGPoint pauseButtonPosition = CGPointMake(pauseButtonX, 0.0);
    pauseButton.position = pauseButtonPosition;
    pauseButton.zPosition = self.statusBarSprite.zPosition + 1.0;
    
    [self.statusBarSprite addChild:pauseButton];
}

- (void)redrawHealth
{
    NSInteger healthDifference = self.healthComponent.currentHealth - self.currentHealth;
    NSRange differenceRange;
    BOOL increase;
    
    if (healthDifference > 0)
    {
        differenceRange = NSMakeRange(self.currentHealth, healthDifference);
        increase = YES;
    }
    else
    {
        differenceRange = NSMakeRange(self.healthComponent.currentHealth, fabs(healthDifference));
        increase = NO;
    }
    
    for (NSUInteger i = differenceRange.location; i < NSMaxRange(differenceRange); i++)
    {
        self.healthSprites[i].texture = increase ? self.fullHealthTexture : self.emptyHealthTexture;
    }
}

- (void)healthDidChange
{
    [self redrawHealth];
    self.currentHealth = self.healthComponent.currentHealth;
}

- (void)dealloc
{
    [_healthSprites release];
    [_fullHealthTexture release];
    [_emptyHealthTexture release];
    [_statusBarSprite release];
    
    [super dealloc];
}

@end
