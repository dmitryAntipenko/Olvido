//
//  OGObstacleNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGObstacleNode : SKNode

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, retain) SKColor *color;

@end
