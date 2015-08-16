//
//  GameResult.m
//  PetyJumper
//
//  Created by Sosnovik on 04.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "GameResult.h"

#define BEST_SCORE_KEY @"BestScore"
#define CURRENT_SCORE_KEY @"CurrentScore"

@interface GameResult()


@end




@implementation GameResult



-(void)setScore:(NSUInteger)score{
    _score=score;
    [self synchronize];
}


-(void)synchronize{
    
    NSUInteger score = self.score;
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:CURRENT_SCORE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUInteger bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:BEST_SCORE_KEY];
    if(!bestScore){
        bestScore = 0;
    }
    
    if(self.score>self.bestScore){
        bestScore=score;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:BEST_SCORE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSUInteger)bestScore{
    NSUInteger bestScore=[[NSUserDefaults standardUserDefaults] integerForKey:BEST_SCORE_KEY];
    if(!bestScore){
        bestScore= 0;
    }
    return bestScore;
}

@end
