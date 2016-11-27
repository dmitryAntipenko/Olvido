//
//  OGMessageComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMessageComponent.h"

CGFloat const OGMessageComponentYOffset = 40.0;
CGFloat const OGMessageComponentLabelFontSize = 32.0;
CGFloat const OGMessageComponentLabelColorBlendFactor = 1.0;
NSString *const OGMessageComponentClearMessage = @"";

@interface OGMessageComponent ()

@property (nonatomic, strong) NSMutableArray<SKSpriteNode *> *sprites;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *messages;
@property (nonatomic, strong) SKSpriteNode *target;
@property (nonatomic, assign) CGFloat minDistance;
@property (nonatomic, strong) SKLabelNode *messageLabel;
@property (nonatomic, assign, getter=isOverlayed) BOOL overlayed;

@end

@implementation OGMessageComponent

- (instancetype)initWithTarget:(SKSpriteNode *)target minShowDistance:(CGFloat)distance labelNode:(SKLabelNode *)labelNode
{
    if (target && distance > 0.0)
    {
        self = [super init];
        
        if (self)
        {
            _target = target;
            _minDistance = distance;
            _messageLabel = labelNode;
            
            _messages = [[NSMutableDictionary alloc] init];
            _sprites = [[NSMutableArray alloc] init];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)didAddToEntity
{
    CGPoint messagePosition = CGPointMake(0.0, CGRectGetHeight(self.target.calculateAccumulatedFrame) / 2.0 + OGMessageComponentYOffset);
    self.messageLabel.position = messagePosition;    
    [self.target addChild:self.messageLabel];
}

- (void)showMessage:(NSString *)message duration:(CGFloat)duration shouldOverlay:(BOOL)shouldOverlay
{
    self.messageLabel.text = message;
    self.overlayed = shouldOverlay;
    
    SKAction *messageDelay = [SKAction waitForDuration:duration];
    [self.messageLabel runAction:messageDelay completion:^()
    {
        self.messageLabel.text = OGMessageComponentClearMessage;
        self.overlayed = NO;
    }];
}

- (void)addMessage:(NSString *)message forSprite:(SKSpriteNode *)sprite
{
    if (message && sprite)
    {
        [self.sprites addObject:sprite];
        
        NSUInteger index = [self.sprites indexOfObject:sprite];
        [self.messages setObject:message forKey:@(index)];
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (!self.isOverlayed)
    {
        for (NSNumber *key in self.messages.allKeys)
        {
            SKSpriteNode *sprite = self.sprites[key.integerValue];
            
            CGFloat distance = hypot(sprite.position.x - self.target.position.x, sprite.position.y - self.target.position.y);
            
            if (distance <= self.minDistance)
            {
                self.messageLabel.text = self.messages[key];
            }
            else
            {
                self.messageLabel.text = OGMessageComponentClearMessage;
            }
        }
    }
}

@end
