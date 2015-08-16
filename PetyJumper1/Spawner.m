//
//  Spawner.m
//  PetyJumper
//
//  Created by Sosnovik on 02.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "Spawner.h"
#import "Colors.h"
#import "Constants.h"




static const uint32_t peterCategory     =  0x1 << 0;
static const uint32_t barierCategory    =  0x1 << 1;
//static const uint32_t waterCategory     =  0x1 << 2;

@implementation Spawner

+(SKSpriteNode *)peter{
    SKSpriteNode *node=[SKSpriteNode spriteNodeWithImageNamed:@"peter"];
    node.name=@"PETER";
    node.zPosition=PETER_Z_POSITION;
    node.physicsBody=[SKPhysicsBody bodyWithTexture:node.texture size:node.texture.size];
    [node.physicsBody setDynamic:YES];
    [node.physicsBody setAffectedByGravity:NO];
    node.physicsBody.mass=1;
    node.physicsBody.categoryBitMask=peterCategory;
    node.physicsBody.contactTestBitMask=barierCategory;
//    node.physicsBody.collisionBitMask=barierCategory;
    return node;
}

+(SKSpriteNode *)cloud{
    SKSpriteNode *node=[SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    node.name=@"CLOUD";
    node.zPosition=CLOUD_Z_POSITION;
    return node;
}

+(SKSpriteNode *)waves{
    SKSpriteNode *waves=[SKSpriteNode spriteNodeWithImageNamed:@"waves"];
    waves.zPosition=WAVE_Z_POSITION;
    return waves;
}

+(SKSpriteNode *)columnForScore:(NSUInteger)score{
    SKSpriteNode *node=[SKSpriteNode spriteNodeWithImageNamed:@"column"];
    CGFloat randomWidth = COLUMN_WIDTH;
    if (score > 5) {
        NSUInteger multyplier = (int)score/5;
        if (multyplier > 10) {
            multyplier = 10;
        }
        randomWidth = COLUMN_WIDTH*(1+(1+multyplier/10)*((arc4random()%RAND_MAX)/(RAND_MAX*1.0)));

    }
    node.size=CGSizeMake(randomWidth, COLUMN_HEIGHT);
    node.zPosition=COLUMN_Z_POSITION;
    node.physicsBody=[SKPhysicsBody bodyWithTexture:node.texture size:node.size];
    [node.physicsBody setDynamic:NO];
    [node.physicsBody setAllowsRotation:NO];
    [node.physicsBody setAffectedByGravity:NO];
    node.physicsBody.categoryBitMask=barierCategory;
    node.physicsBody.contactTestBitMask=peterCategory;
//    node.physicsBody.collisionBitMask=peterCategory;
    return node;
}



+(SKShapeNode *)water{
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WATER_WIDTH , WATER_HEIGHT) cornerRadius:0];
    SKShapeNode *node=[[SKShapeNode alloc]init];
    node.path=[path CGPath];
    node.fillColor=[Colors waterColor];
    node.strokeColor=[Colors waterColor];
    node.glowWidth=WATER_GLOW_WIDTH;
    node.name=@"WATER";
    node.zPosition=WATER_Z_POSITION;
    node.physicsBody=[SKPhysicsBody bodyWithEdgeChainFromPath:node.path];
    [node.physicsBody setDynamic:NO];
    [node.physicsBody setAllowsRotation:NO];
    [node.physicsBody setAffectedByGravity:NO];
    node.physicsBody.categoryBitMask=barierCategory;
    node.physicsBody.contactTestBitMask=peterCategory;
    node.physicsBody.collisionBitMask=peterCategory;
    
    
    return node;
}

@end
