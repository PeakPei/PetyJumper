//
//  Spawner.h
//  PetyJumper
//
//  Created by Sosnovik on 02.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface Spawner : NSObject

+(SKSpriteNode *)peter;
+(SKShapeNode *)water;
+(SKSpriteNode *)columnForScore:(NSUInteger)score;
+(SKSpriteNode *)cloud;
+(SKSpriteNode *)waves;





@end
