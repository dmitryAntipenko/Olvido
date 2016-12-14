//
//  OGEnemyBehavior.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyBehavior.h"
#import "OGGameScene.h"
#import "OGEnemyEntity.h"

CGFloat const OGEnemyBehaviorAgentSearchDistanceForFlocking = 50.0;

CGFloat const OGEnemyBehaviorSeparationRadius = 25.3;
CGFloat const OGEnemyBehaviorSeparationAngle = (CGFloat) (3 * M_PI_4);
CGFloat const OGEnemyBehaviorSeparationWeight = 2.0;
                                                          
CGFloat const OGEnemyBehaviorAlignmentRadius = 43.333;
CGFloat const OGEnemyBehaviorAlignmentAngle = (CGFloat) M_PI_4;
CGFloat const OGEnemyBehaviorAlignmentWeight = 1.667;

CGFloat const OGEnemyBehaviorCohesionRadius = 50.0;
CGFloat const OGEnemyBehaviorCohesionAngle = (CGFloat) M_PI_2;
CGFloat const OGEnemyBehaviorCohesionWeight = 1.667;

NSTimeInterval const OGEnemyBehaviorMaxPredictionTimeWhenFollowingPath = 1.0;

NSString *const OGEnemyBehaviorBehaviorKey = @"behavior";
NSString *const OGEnemyBehaviorPathPointsKey = @"pathPoints";

@implementation OGEnemyBehavior

+ (GKBehavior *)behaviorWithAgent:(GKAgent2D *)agent
                     huntingAgent:(GKAgent2D *)huntingAgent
                       pathRadius:(CGFloat)pathRadius
                            scene:(OGGameScene *)scene;
{
    OGEnemyBehavior *enemyBehavior = [[OGEnemyBehavior alloc] init];
    [enemyBehavior addTargetSpeedGoalWithSpeed:agent.maxSpeed];
    [enemyBehavior addAvoidObstaclesGoalWithScene:scene];
    
    NSMutableArray<GKAgent2D *> *agentsToFlockWith = [NSMutableArray array];
    
    for (GKEntity *entity in scene.entities)
    {
        OGEnemyEntity *enemyEntity = (OGEnemyEntity *) entity;
        
        if ([entity isKindOfClass:[OGEnemyEntity class]]
            && enemyEntity.agent != agent
            && [enemyEntity distanceToAgentWithOtherAgent:agent] <= OGEnemyBehaviorAgentSearchDistanceForFlocking)
        {
            [agentsToFlockWith addObject:((OGEnemyEntity *) entity).agent];
        }
    }

    if (agentsToFlockWith.count != 0)
    {
        GKGoal *separationGoal = [GKGoal goalToSeparateFromAgents:agentsToFlockWith
                                                      maxDistance:OGEnemyBehaviorSeparationRadius
                                                         maxAngle:OGEnemyBehaviorSeparationAngle];
        [enemyBehavior setWeight:OGEnemyBehaviorSeparationWeight forGoal:separationGoal];
        
        GKGoal *alignmentGoal = [GKGoal goalToAlignWithAgents:agentsToFlockWith
                                                  maxDistance:OGEnemyBehaviorAlignmentRadius
                                                     maxAngle:OGEnemyBehaviorAlignmentAngle];
        [enemyBehavior setWeight:OGEnemyBehaviorAlignmentWeight forGoal:alignmentGoal];    
        
        GKGoal *cohesionGoal = [GKGoal goalToCohereWithAgents:agentsToFlockWith
                                                  maxDistance:OGEnemyBehaviorCohesionRadius
                                                     maxAngle:OGEnemyBehaviorCohesionAngle];
        
        [enemyBehavior setWeight:OGEnemyBehaviorCohesionWeight forGoal:cohesionGoal];
    }
    
    CGPoint agentPosition = CGPointMake(agent.position.x, agent.position.y);
    CGPoint huntingAgentPosition = CGPointMake(huntingAgent.position.x, huntingAgent.position.y);
    
    [enemyBehavior addGoalsToFollowPathWithStartPoint:agentPosition
                                             endPoint:huntingAgentPosition
                                           pathRadius:pathRadius
                                                scene:scene];
    
    return enemyBehavior;
}

+ (GKBehavior *)behaviorWithAgent:(GKAgent2D *)agent
                         endPoint:(CGPoint)endPoint
                       pathRadius:(CGFloat)pathRadius
                            scene:(OGGameScene *)scene
{
    OGEnemyBehavior *enemyBehavior = [[OGEnemyBehavior alloc] init];
    
    [enemyBehavior addTargetSpeedGoalWithSpeed:agent.maxSpeed];
    [enemyBehavior addAvoidObstaclesGoalWithScene:scene];
    
    CGPoint startPoint = CGPointMake(agent.position.x, agent.position.y);
    
    [enemyBehavior addGoalsToFollowPathWithStartPoint:startPoint
                                             endPoint:endPoint
                                           pathRadius:pathRadius
                                                scene:scene];
    
    return enemyBehavior;
}

+ (GKBehavior *)behaviorWithAgent:(GKAgent2D *)agent
                            graph:(GKGraph *)graph
                       pathRadius:(CGFloat)pathRadius
                            scene:(OGGameScene *)scene
{
    OGEnemyBehavior *enemyBehavior = [[OGEnemyBehavior alloc] init];
    [enemyBehavior addTargetSpeedGoalWithSpeed:agent.maxSpeed];
    [enemyBehavior addAvoidObstaclesGoalWithScene:scene];
    
    GKPath *path = [GKPath pathWithGraphNodes:graph.nodes radius:pathRadius];
    path.cyclical = YES;
    
    [enemyBehavior addFollowAndStayOnPathGoalsWithPath:path];
    
    return enemyBehavior;
}

- (NSArray<GKPolygonObstacle *> *)extrudedObstaclesContainingPoint:(CGPoint)point
                                                             scene:(OGGameScene *)scene
{
    CGFloat extrusionRadius = (CGFloat) OGEnemyEntityPathfindingGraphBufferRadius + 5.0;
    
    NSMutableArray<GKPolygonObstacle *> *result = [NSMutableArray array];
    
    for (GKPolygonObstacle *obstacle in scene.polygonObstacles)
    {
        NSMutableArray<NSValue *> *polygonVertices = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < obstacle.vertexCount; i++)
        {
            vector_float2 vertexFloat2 = [obstacle vertexAtIndex:i];
            CGPoint vertexPoint = CGPointMake(vertexFloat2.x, vertexFloat2.y);
            
            [polygonVertices addObject:[NSValue valueWithCGPoint:vertexPoint]];
        }
        
        if (polygonVertices.count > 0)
        {
            for (NSUInteger i = 0; i < polygonVertices.count - 1; i++)
            {
                if (i != polygonVertices.count)
                {
                    CGFloat x = polygonVertices[i].CGPointValue.x;
                    CGFloat y = polygonVertices[i].CGPointValue.y;
                    
                    CGFloat nextX = polygonVertices[i + 1].CGPointValue.x;
                    CGFloat nextY = polygonVertices[i + 1].CGPointValue.y;
                    
                    CGFloat maxX = MAX(x, nextX) + extrusionRadius;
                    CGFloat maxY = MAX(y, nextY) + extrusionRadius;
                    
                    CGFloat minX = MIN(x, nextX) - extrusionRadius;
                    CGFloat minY = MIN(y, nextY) - extrusionRadius;
                    
                    if ((point.x > minX && point.x < maxX)
                        && (point.y > minY && point.y < maxY))
                    {
                        [result addObject:obstacle];
                    }
                }
            }
        }
    }
    
    if (result.count == 0)
    {
        result = nil;
    }
    
    return result;
}

- (GKGraphNode2D *)connectedNodeWithPoint:(CGPoint)point onObstacleGraphInScene:(OGGameScene *)scene
{
    GKGraphNode2D *pointNode = [GKGraphNode2D nodeWithPoint:(vector_float2){point.x, point.y}];
    
    [scene.obstaclesGraph connectNodeUsingObstacles:pointNode];

    if (pointNode.connectedNodes.count == 0 && scene.obstaclesGraph.nodes.count > 1)
    {
        [scene.obstaclesGraph removeNodes:@[pointNode]];
        
        NSArray<GKPolygonObstacle *> *intersectingObstacles = [self extrudedObstaclesContainingPoint:point scene:scene];
        [scene.obstaclesGraph connectNodeUsingObstacles:pointNode ignoringBufferRadiusOfObstacles:intersectingObstacles];
        
        if (pointNode.connectedNodes.count == 0)
        {
            [scene.obstaclesGraph removeNodes:@[pointNode]];
            pointNode = nil;
        }
    }
    
    return pointNode;
}

- (NSArray<NSValue *> *)addGoalsToFollowPathWithStartPoint:(CGPoint)startPoint
                                                  endPoint:(CGPoint)endPoint
                                                pathRadius:(CGFloat)pathRadius
                                                     scene:(OGGameScene *)scene
{
    NSMutableArray<NSValue *> *result = [NSMutableArray array];
    
    GKGraphNode2D *startNode = [self connectedNodeWithPoint:startPoint onObstacleGraphInScene:scene];
    GKGraphNode2D *endNode = [self connectedNodeWithPoint:endPoint onObstacleGraphInScene:scene];
    
    if (startNode && endNode)
    {
        NSArray *pathNodes = [scene.obstaclesGraph findPathFromNode:startNode toNode:endNode];
        
        if (pathNodes.count > 1)
        {
            GKPath *path = [GKPath pathWithGraphNodes:pathNodes radius:pathRadius];
            
            [self addFollowAndStayOnPathGoalsWithPath:path];            
            
            for (GKGraphNode2D *node in pathNodes)
            {
                CGPoint position = CGPointMake(node.position.x, node.position.y);
                [result addObject:[NSValue valueWithCGPoint:position]];
            }
        }
        
        [scene.obstaclesGraph removeNodes:@[startNode, endNode]];
    }
    
    
    return result;
}

- (void)addTargetSpeedGoalWithSpeed:(CGFloat)speed
{
    [self setWeight:1.0 forGoal:[GKGoal goalToReachTargetSpeed:speed]];
}

- (void)addAvoidObstaclesGoalWithScene:(OGGameScene *)scene
{
    [self setWeight:1.0 forGoal:[GKGoal goalToAvoidObstacles:scene.polygonObstacles
                                           maxPredictionTime:OGEnemyEntityMaxPredictionTimeForObstacleAvoidance]];
}

- (void)addFollowAndStayOnPathGoalsWithPath:(GKPath *)path
{
    [self setWeight:1.0 forGoal:[GKGoal goalToFollowPath:path
                                       maxPredictionTime:OGEnemyBehaviorMaxPredictionTimeWhenFollowingPath
                                                 forward:YES]];
    
    [self setWeight:1.0 forGoal:[GKGoal goalToStayOnPath:path
                                       maxPredictionTime:OGEnemyBehaviorMaxPredictionTimeWhenFollowingPath]];
}

@end
