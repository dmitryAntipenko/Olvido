//
//  OGAnimationState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimationState.h"

@interface OGAnimationState ()

@property (nonatomic, strong) NSArray<NSString *> *validNextStates;

@end

@implementation OGAnimationState

+ (instancetype)animationStateWithName:(NSString *)name textures:(NSArray<SKTexture *> *)textures validNextStates:(NSArray<NSString *> *)validStates
{
    return [[OGAnimationState alloc] initWithName:name textures:textures validNextStates:validStates];
}

- (instancetype)initWithName:(NSString *)name textures:(NSArray<SKTexture *> *)textures validNextStates:(NSArray<NSString *> *)validStates
{
    if (name && textures)
    {
        self = [super init];
        
        if (self)
        {
            _name = name;
            _textures = textures;
            _validNextStates = validStates;
        }
        
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (BOOL)isValidNextState:(OGAnimationState *)nextState
{
    BOOL result = YES;
    
    if (self.validNextStates)
    {
        result = NO;
        
        for (OGAnimationState *state in self.validNextStates)
        {
            result = result || [state.name isEqualToString:nextState.name];
        }
    }
    
    return result;
}


@end
