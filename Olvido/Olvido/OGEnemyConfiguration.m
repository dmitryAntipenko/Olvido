//
//  OGEnemyConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyConfiguration.h"

@interface OGEnemyConfiguration ()

@property (nonatomic, copy, readwrite) NSString *initialPointName;
@property (nonatomic, assign, readwrite) CGVector initialVector;

@property (nonatomic, copy) NSDictionary *configurationDictionary;

@end

@implementation OGEnemyConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
        if (self)
        {
            _initialPointName = dictionary[@"InitialPoint"];
            
            CGFloat dx = [dictionary[@"InitialVector"][@"dx"] floatValue];
            CGFloat dy = [dictionary[@"InitialVector"][@"dy"] floatValue];
            _initialVector = CGVectorMake(dx, dy);
        }
    }
    
    return self;
}



@end
