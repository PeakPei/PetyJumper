//
//  GameResult.h
//  PetyJumper
//
//  Created by Sosnovik on 04.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface GameResult : NSObject

@property (nonatomic) NSUInteger score;
@property (nonatomic, readonly) NSUInteger bestScore;

@end
