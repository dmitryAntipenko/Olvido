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

CGFloat const kOGEnemyBehaviorAgentSearchDistanceForFlocking = 50.0;

CGFloat const kOGEnemyBehaviorSeparationRadius = 25.3;
CGFloat const kOGEnemyBehaviorSeparationAngle = (CGFloat) (3 * M_PI_4);
CGFloat const kOGEnemyBehaviorSeparationWeight = 2.0;
                                                          
CGFloat const kOGEnemyBehaviorAlignmentRadius = 43.333;
CGFloat const kOGEnemyBehaviorAlignmentAngle = (CGFloat) M_PI_4;
CGFloat const kOGEnemyBehaviorAlignmentWeight = 1.667;

CGFloat const kOGEnemyBehaviorCohesionRadius = 50.0;
CGFloat const kOGEnemyBehaviorCohesionAngle = (CGFloat) M_PI_2;
CGFloat const kOGEnemyBehaviorCohesionWeight = 1.667;

NSTimeInterval const kOGEnemyBehaviorMaxPredictionTimeWhenFollowingPath = 1.0;

NSString *const kOGEnemyBehaviorBehaviorKey = @"behavior";
NSString *const kOGEnemyBehaviorPathPointsKey = @"pathPoints";

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
        if (entity && [entity isKindOfClass:[OGEnemyEntity class]] && ((OGEnemyEntity *) entity).agent != agent
            && [((OGEnemyEntity *) entity) distanceToAgentWithOtherAgent:agent] <= kOGEnemyBehaviorAgentSearchDistanceForFlocking)
        {
            [agentsToFlockWith addObject:((OGEnemyEntity *) entity).agent];
        }
    }

    if ([agentsToFlockWith count] != 0)
    {
        GKGoal *separationGoal = [GKGoal goalToSeparateFromAgents:agentsToFlockWith
                                                      maxDistance:kOGEnemyBehaviorSeparationRadius
                                                         maxAngle:kOGEnemyBehaviorSeparationAngle];
        [enemyBehavior setWeight:kOGEnemyBehaviorSeparationWeight forGoal:separationGoal];
        
        GKGoal *alignmentGoal = [GKGoal goalToAlignWithAgents:agentsToFlockWith
                                                  maxDistance:kOGEnemyBehaviorAlignmentRadius
                                                     maxAngle:kOGEnemyBehaviorAlignmentAngle];
        [enemyBehavior setWeight:kOGEnemyBehaviorAlignmentWeight forGoal:alignmentGoal];    
        
        GKGoal *cohesionGoal = [GKGoal goalToCohereWithAgents:agentsToFlockWith
                                                  maxDistance:kOGEnemyBehaviorCohesionRadius
                                                     maxAngle:kOGEnemyBehaviorCohesionAngle];
        
        [enemyBehavior setWeight:kOGEnemyBehaviorCohesionWeight forGoal:cohesionGoal];
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
    CGFloat extrusionRadius = (CGFloat) kOGEnemyEntityPathfindingGraphBufferRadius + 5.0;
    
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
        
        if ([polygonVertices count] > 0)
        {
            for (NSUInteger i = 0; i < polygonVertices.count; i++)
            {
                if (i != polygonVertices.count)
                {
                    CGFloat x = polygonVertices[i].CGPointValue.x;
                    CGFloat y = polygonVertices[i].CGPointValue.y;
                    
                    CGFloat nextX = polygonVertices[i + 1].CGPointValue.x;
                    CGFloat nextY = polygonVertices[i + 1].CGPointValue.y;
                    
                    CGFloat maxX = ((x > nextX) ? x : nextX) + extrusionRadius;
                    CGFloat maxY = ((y > nextY) ? y : nextY) + extrusionRadius;
                    
                    CGFloat minX = ((x < nextX) ? x : nextX) - extrusionRadius;
                    CGFloat minY = ((y < nextY) ? y : nextY) - extrusionRadius;
                    
                    if ((point.x > minX && point.x < maxX) && (point.y > minY && point.y < maxY))
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
    
    if (pointNode.connectedNodes.count == 0 && scene.obstaclesGraph.nodes.count != 1)
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
        
        if ([pathNodes count] > 1)
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
    [self setWeight:0.5 forGoal:[GKGoal goalToReachTargetSpeed:speed]];
}

- (void)addAvoidObstaclesGoalWithScene:(OGGameScene *)scene
{
    [self setWeight:1.0 forGoal:[GKGoal goalToAvoidObstacles:scene.polygonObstacles
                                           maxPredictionTime:kOGEnemyEntityMaxPredictionTimeForObstacleAvoidance]];
}

- (void)addFollowAndStayOnPathGoalsWithPath:(GKPath *)path
{
    [self setWeight:1.0 forGoal:[GKGoal goalToFollowPath:path
                                       maxPredictionTime:kOGEnemyBehaviorMaxPredictionTimeWhenFollowingPath
                                                 forward:YES]];
    
    [self setWeight:1.0 forGoal:[GKGoal goalToStayOnPath:path
                                       maxPredictionTime:kOGEnemyBehaviorMaxPredictionTimeWhenFollowingPath]];
}

@end
