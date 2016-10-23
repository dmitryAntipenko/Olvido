//
//  OGMessageComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMessageComponent.h"

CGFloat const kOGMessageComponentYOffset = 20.0;
CGFloat const kOGMessageComponentLabelFontSize = 32.0;
CGFloat const kOGMessageComponentLabelColorBlendFactor = 1.0;
NSString *const kOGMessageComponentClearMessage = @"";

@interface OGMessageComponent ()

@property (nonatomic, retain) NSMutableArray<SKSpriteNode *> *sprites;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, NSString *> *messages;
@property (nonatomic, retain) SKSpriteNode *target;
@property (nonatomic, assign) CGFloat minDistance;
@property (nonatomic, retain) SKLabelNode *messageLabel;

@end

@implementation OGMessageComponent

- (instancetype)initWithTarget:(SKSpriteNode *)target minShowDistance:(CGFloat)distance
{
    if (target && distance > 0.0)
    {
        self = [super init];
        
        if (self)
        {
            _target = [target retain];
            _minDistance = distance;
            _messageLabel = [[SKLabelNode alloc] init];
            
            _messages = [[NSMutableDictionary alloc] init];
            _sprites = [[NSMutableArray alloc] init];
        }
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)didAddToEntity
{
    CGPoint messagePosition = CGPointMake(0.0, self.target.size.height / 2.0 + kOGMessageComponentYOffset);
    
    self.messageLabel.position = messagePosition;
    self.messageLabel.color = [SKColor blackColor];
    self.messageLabel.colorBlendFactor = kOGMessageComponentLabelColorBlendFactor;
    self.messageLabel.fontSize = kOGMessageComponentLabelFontSize;
    
    [self.target addChild:self.messageLabel];
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
            self.messageLabel.text = kOGMessageComponentClearMessage;
        }
    }
}

- (void)dealloc
{
    [_target release];
    [_messages release];
    [_messageLabel release];
    [_sprites release];
    
    [super dealloc];
}

@end
