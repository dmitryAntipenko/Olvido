//
//  OGPlayerEntityAppearState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityAppearState.h"
#import "OGPlayerEntity.h"
#import "OGPlayerEntity+OGPlayerEntityResources.h"

#import "OGAnimationComponent.h"
#import "OGRenderComponent.h"
#import "OGOrientationComponent.h"
#import "OGInputComponent.h"
#import "OGDirection.h"
#import "OGPlayerEntityControlledState.h"

CGFloat const kOGPlayerEntityAppearStateDurationTime = 3.0;

@interface OGPlayerEntityAppearState ()

@property (nonatomic, weak) OGPlayerEntity *playerEntity;

@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong) OGInputComponent *inputComponent;

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@end

@implementation OGPlayerEntityAppearState

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _elapsedTime = 0.0;
    }
    
    return self;
}

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity
{
    self = [self init];
    
    if (self)
    {
        _playerEntity = playerEntity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.elapsedTime = 0.0;
    
    NSDictionary *appearTextures = [OGPlayerEntity sOGPlayerEntityAppearTextures];
    
    if (appearTextures)
    {
        SKTexture *texture = appearTextures[kOGDirectionDescription[self.orientationComponent.direction]];
        
        self.spriteNode.texture = texture;
        self.spriteNode.size = [OGPlayerEntity textureSize];
        
        [self.renderComponent.node addChild:self.spriteNode];
        
        [self.animationComponent.spriteNode setHidden:YES];
        
        [self.inputComponent setEnabled:NO];
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;
    
    if (self.elapsedTime > kOGPlayerEntityAppearStateDurationTime)
    {
        [self.spriteNode removeFromParent];
        
        if ([self.stateMachine canEnterState:OGPlayerEntityControlledState.self])
        {
            [self.stateMachine enterState:OGPlayerEntityControlledState.self];
        }
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGPlayerEntityControlledState.self;
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
    
    [self.animationComponent.spriteNode setHidden:NO];
    
    [self.inputComponent setEnabled:YES];
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.playerEntity componentForClass:OGAnimationComponent.self];
    }
    
    return _animationComponent;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.playerEntity componentForClass:OGRenderComponent.self];
    }
    
    return _renderComponent;
}

- (OGOrientationComponent *)orientationComponent
{
    if (!_orientationComponent)
    {
        _orientationComponent = (OGOrientationComponent *) [self.playerEntity componentForClass:OGOrientationComponent.self];
    }
    
    return _orientationComponent;
}

- (OGInputComponent *)inputComponent
{
    if (!_inputComponent)
    {
        _inputComponent = (OGInputComponent *) [self.playerEntity componentForClass:OGInputComponent.self];
    }
    
    return _inputComponent;
}

- (SKSpriteNode *)spriteNode
{
    if (!_spriteNode)
    {
        _spriteNode = [[SKSpriteNode alloc] init];
    }
    
    return _spriteNode;
}

@end
