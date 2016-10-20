//
//  OGStoryPage.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryPage.h"

@interface OGStoryPage ()

@property (nonatomic, copy) NSMutableArray<NSString *> *mutableReplicas;

@end

@implementation OGStoryPage

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableReplicas = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_mutableReplicas release];
    
    [super dealloc];
}

- (NSArray<NSString *> *)replicas
{
    return [[self.mutableReplicas copy] autorelease];
}

- (void)addReplica:(NSString *)replica
{
    
}

- (void)removeReplica:(NSString *)replica
{
    
}


@end
