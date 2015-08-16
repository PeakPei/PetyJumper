//
//  GameScene.m
//  PetyJumper
//
//  Created by Sosnovik on 02.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "GameScene.h"
#import "Spawner.h"
#import "Colors.h"
#import "Constants.h"
#import "GameResult.h"
#import "GameViewController.h"
#import "ShareScene.h"
#import <QuartzCore/QuartzCore.h>



@interface GameScene()<SKPhysicsContactDelegate>

@property(nonatomic, strong) SKSpriteNode *peter;
@property(nonatomic, strong) SKShapeNode *water;
@property(nonatomic) NSUInteger score;
@property(nonatomic, strong) SKLabelNode *scoreLabel;
@property(nonatomic, strong) NSMutableArray *arrayOfColumns;
@property(nonatomic) BOOL peterFalls;
@property(nonatomic) CGFloat peterAngle;



@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {

    
    self.backgroundColor=[Colors skyColor];
    self.anchorPoint=CGPointMake(0.5, 0.5);
    [self drawWater];
    [self drawWaves];

    self.physicsWorld.gravity = CGVectorMake(0,-G_FACTOR);
    self.physicsWorld.contactDelegate = self;
    

    [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(addColumn:) userInfo:nil repeats:YES];
    [self newGame];
//    SKAction *music=[SKAction playSoundFileNamed:@"P.mp3" waitForCompletion:YES];
//    SKAction *cycleMusic=[SKAction repeatActionForever:music];
//    [self runAction:cycleMusic];
    


    
}
/*
-(void) drawTutorialScene{


    SKShapeNode *backGroungNode=[[SKShapeNode alloc] init];
    UIBezierPath *square=[UIBezierPath bezierPathWithRect:CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height)];
    backGroungNode.path=[square CGPath];
    backGroungNode.fillColor=[Colors waterColor];
    backGroungNode.strokeColor=[Colors waterColor];
    backGroungNode.zPosition=TUTORIAL_SCENE_Z_POSITION;
    backGroungNode.name=@"TUTORIAL";
    [self addChild:backGroungNode];
    
    SKSpriteNode *tut2=[SKSpriteNode spriteNodeWithImageNamed:@"tut2"];
    tut2.position=CGPointMake(4, -3.5);
    CGSize newSize = CGSizeMake(160.0, 160.0*tut2.size.height/tut2.size.width);
    tut2.size = newSize;
    [backGroungNode addChild:tut2];
    SKAction *bigger=[SKAction scaleBy:1.1 duration:DISAPEAR_DURATION/2];
    SKAction *smaller=[SKAction scaleBy:1/1.1 duration:DISAPEAR_DURATION/2];
    SKAction *cycle=[SKAction repeatActionForever:[SKAction sequence:@[bigger,smaller]]];
    [tut2 runAction:cycle];

    
}*/

-(void)newGame{
    if (!self.water) {
        [self drawWater];
        [self drawWaves];
    }
    [self.arrayOfColumns removeAllObjects];
    self.score=0.0;
    [self drawPeter];
    [self drawCloudAtHeight:-20];
    [self drawCloudAtHeight:60];
    [self drawCloudAtHeight:140];
    [self drawCloudAtHeight:220];
    [self moveWaves];

    
    
}


-(void)moveWaves{
    for(SKSpriteNode *node in self.children){
        SKAction *completion=[SKAction moveByX:-node.position.x-WAVELENGTH y:0.0 duration:(WAVELENGTH+node.position.x)*COLUMN_DURATION/600];
        if([node.name isEqualToString:@"WAVE1"]||[node.name isEqualToString:@"WAVE2"]){
            SKAction *setPosition=[SKAction runBlock:^{[node setPosition:CGPointMake(WAVELENGTH, -WATER_POSITION)];}];
            SKAction *move=[SKAction moveByX:-2*WAVELENGTH y:0.0 duration:2*WAVELENGTH/600*COLUMN_DURATION];
            SKAction *cycle=[SKAction sequence:@[setPosition, move]];
            SKAction *sequence=[SKAction sequence:@[completion,[SKAction repeatActionForever:cycle]]];
            [node runAction:sequence];
        }
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    [self gameOver];
    
}

-(void)gameOver{


    for (SKSpriteNode *node in self.children){
        [node removeAllActions];
    }

    self.peter.physicsBody.allowsRotation=NO;
    self.peter.physicsBody.dynamic=NO;
    
    for(SKSpriteNode *node in self.arrayOfColumns){
        SKAction *move=[SKAction moveByX:340 y:0.0 duration:DISAPEAR_DURATION];
        [node runAction:[SKAction sequence:@[move,[SKAction removeFromParent]]]];
    }
    for(SKSpriteNode *node in self.children){
        if([node.name isEqualToString:@"CLOUD"]||[node.name isEqualToString:@"COLUMN_GONE"]){
            SKAction *move=[SKAction moveByX:-700 y:0.0 duration:DISAPEAR_DURATION];
            [node runAction:[SKAction sequence:@[move,[SKAction removeFromParent]]]];
        }
        
        if([node.name isEqualToString:@"PETER"]){
            SKAction *rotate=[SKAction rotateByAngle:-M_PI/3+self.peterAngle duration:DISAPEAR_DURATION/2];
            SKAction *move=[SKAction moveByX:0.0 y:-WATER_POSITION-self.peter.position.y-100 duration:DISAPEAR_DURATION*(WATER_POSITION+self.peter.position.y+100)/600];
            [node runAction:[SKAction sequence:@[rotate, move, [SKAction removeFromParent]]]];
            
        }
        if([node.name isEqualToString:@"SCORE"]){
            [node runAction:[SKAction moveByX:0.0 y:-100 duration:DISAPEAR_DURATION]];
        }
        if([node.name isEqualToString:@"RAINBOW"]){
            [node runAction:[SKAction fadeAlphaTo:0 duration:DISAPEAR_DURATION]];
        }
        if([node.name isEqualToString:@"PAUSE"]){
            [node runAction:[SKAction fadeAlphaTo:0 duration:DISAPEAR_DURATION/3]];
        }
    }
    [self drawLastScene];
    
}

-(void)drawLastScene{
    GameResult *results=[[GameResult alloc] init];
    results.score=self.score;
    
    SKLabelNode *scoreTitle=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    scoreTitle.text=@"SCORE";
    scoreTitle.position=CGPointMake(0, 400);
    scoreTitle.fontSize=35;
    [scoreTitle runAction:[SKAction moveByX:0.0 y:-140 duration:DISAPEAR_DURATION]];
    [self   addChild:scoreTitle];
    
    SKLabelNode *bestScoreTitle=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    bestScoreTitle.text=@"BEST";
    bestScoreTitle.position=CGPointMake(0, 140);
    bestScoreTitle.fontSize=35;
    bestScoreTitle.alpha=0;
    [bestScoreTitle runAction:[SKAction fadeAlphaTo:1 duration:DISAPEAR_DURATION]];
    [self   addChild:bestScoreTitle];
    
    
    SKLabelNode *bestScore=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    bestScore.text=[NSString stringWithFormat:@"%d", (int)results.bestScore];
    bestScore.position=CGPointMake(0, 60);
    bestScore.fontSize=50;
    bestScore.alpha=0;
    [bestScore runAction:[SKAction fadeAlphaTo:1 duration:DISAPEAR_DURATION]];
    [self   addChild:bestScore];
    
    
    SKLabelNode *newGameTitle=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    newGameTitle.text=@"↻";
    newGameTitle.position=CGPointMake(0, -50);
    newGameTitle.alpha=0;
    newGameTitle.fontSize=120;
    newGameTitle.name=@"NEW_GAME";
    [newGameTitle runAction:[SKAction fadeAlphaTo:1.0 duration:DISAPEAR_DURATION]];
    [self   addChild:newGameTitle];
    
    SKSpriteNode *share=[SKSpriteNode spriteNodeWithImageNamed:@"share"];
    share.position=CGPointMake(5, -120);
    share.alpha=0;
    [share setScale:0.32];
    share.name=@"SHARE";
    [share runAction:[SKAction fadeAlphaTo:1.0 duration:DISAPEAR_DURATION]];
    
    [self   addChild:share];
}

-(void)drawWaves{
    SKSpriteNode *wave1=[Spawner waves];
    wave1.position=CGPointMake(0, -WATER_POSITION);
    wave1.size=CGSizeMake(WAVELENGTH, wave1.size.height);
    wave1.alpha=1;
    wave1.name=@"WAVE1";
    [self addChild:wave1];
    
    SKSpriteNode *wave2=[Spawner waves];
    wave2.position=CGPointMake(WAVELENGTH, -WATER_POSITION);
    wave2.size=CGSizeMake(WAVELENGTH, wave2.size.height);
    wave2.alpha=1;
    wave2.name=@"WAVE2";
    [self addChild:wave2];
}

-(NSMutableArray *)arrayOfColumns{
    if(!_arrayOfColumns){
        _arrayOfColumns=[NSMutableArray array];
    }
    return _arrayOfColumns;
}

-(void)addColumn:(NSTimer *)timer{
    if(self.peter.physicsBody.affectedByGravity && self.peter.physicsBody.dynamic){
        [self drawColumnWithHoleAtHeight:[self randomFloatBetween:-100 and: 280]];
    }
}

-(void)drawWater{
    self.water=[Spawner water];
    self.water.position=CGPointMake(-self.water.frame.size.width/2, -self.water.frame.size.height-WATER_POSITION);
    [self addChild:self.water];
    
}

-(void)drawColumnWithHoleAtHeight:(CGFloat) height{
    

    SKSpriteNode *topColumn=[Spawner columnForScore:self.score];
    topColumn.position=CGPointMake(300, height+HOLE_HEIGHT/2+[self columnHeight]/2);
    SKAction *moveLeft=[SKAction moveByX:-600 y:0.0 duration:COLUMN_DURATION];
    SKAction *remove=[SKAction removeFromParent];
    SKAction *sequence=[SKAction sequence:@[moveLeft, remove]];
    [topColumn runAction:sequence];
    topColumn.name=@"T_COLUMN";
    [self addChild:topColumn];
    [self.arrayOfColumns addObject:topColumn];
    
    SKSpriteNode *bottomColumn=[Spawner columnForScore:self.score];
    bottomColumn.position=CGPointMake(300, height-HOLE_HEIGHT/2-[self columnHeight]/2);
    [bottomColumn runAction:sequence];
    bottomColumn.name=@"B_COLUMN";
    [self addChild:bottomColumn];
    [self.arrayOfColumns addObject:bottomColumn];
    
    
}

-(CGFloat)columnHeight{
    SKSpriteNode *node=[Spawner columnForScore:self.score];
    return node.size.height;
}

-(void)drawScore{
    SKLabelNode *score=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    score.text=[NSString stringWithFormat: @"%d", (int)self.score];
    score.fontSize=50;
    score.position=CGPointMake(0, 300);
    score.zPosition=SCORE_Z_POSITION;
    score.name=@"SCORE";
    self.scoreLabel=score;
    [self addChild:score];
}

-(void)drawCloudAtHeight:(CGFloat)height{
    SKSpriteNode *cloud=[Spawner cloud];
    cloud.size=CGSizeMake([self randomFloatBetween:80 and:200], [self randomFloatBetween:40 and:70]);
    cloud.position=CGPointMake([self randomFloatBetween:300 and:600], height);
    SKAction *motion=[SKAction sequence:@[[SKAction moveByX:-900 y:0.0 duration:[self randomFloatBetween:20 and:40]],[SKAction runBlock:^{[cloud setPosition:CGPointMake([self randomFloatBetween:300 and:400], height)]; [cloud setScale:[self randomFloatBetween:0.7 and:1]];}]]];
    [cloud runAction:[SKAction repeatActionForever:motion]];
    [self addChild:cloud];
    
    SKSpriteNode *firstCloud=[Spawner cloud];
    firstCloud.size=CGSizeMake([self randomFloatBetween:80 and:200], [self randomFloatBetween:40 and:70]);
    firstCloud.position=CGPointMake([self randomFloatBetween:-300 and:0], height);
    firstCloud.alpha=0;
    SKAction *move=[SKAction group:@[[SKAction fadeAlphaTo:1 duration:DURATION_TO_APEAR],[SKAction moveByX:-700 y:0.0 duration:[self  randomFloatBetween:20 and:40]]]];
    SKAction *remove=[SKAction removeFromParent];
    [firstCloud runAction:[SKAction sequence:@[move,remove]]];
    [self addChild:firstCloud];
}

-(void)drawPeter{
    self.peter=[Spawner peter];
    self.peter.position=CGPointMake(0, 0);
    [self.peter setScale:0.45];
    self.peter.alpha=0;
    [self.peter runAction:[SKAction fadeAlphaTo:1 duration:DURATION_TO_APEAR]];
    [self addChild:self.peter];
}

-(void)childrenAreRemoved{
    if(self.children.count==3){
        [self newGame];
    }
    if (!self.children.count) {
        self.water=nil;
        [self newGame];
    }
}

-(CGFloat)randomFloatBetween:(CGFloat) min and:(CGFloat) max {
    CGFloat random=((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(max-min)+min;
    return random;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{


    UITouch *touch=[touches anyObject];
    SKNode *node=[self nodeAtPoint:[touch locationInNode:self]];

    if([node.name isEqualToString:@"NEW_GAME"]&&node.alpha==1){
        for(SKSpriteNode *node in self.children){
            if(![node.name isEqualToString:@"WATER"]&&![node.name isEqualToString:@"WAVE1"]&&![node.name isEqualToString:@"WAVE2"]){
                [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:DISAPEAR_DURATION/2],[SKAction removeFromParent]]] completion:^{[self childrenAreRemoved];}];
            }
        }
    }
    
    if ([node.name isEqualToString:@"SHARE"]) {

        for (SKNode *node in self.children){
            CGFloat shift = 0.0;
            if ([node.name isEqualToString:@"WATER"] ||[node.name isEqualToString:@"WAVE1"] ||[node.name isEqualToString:@"WAVE2"]||[node.name isEqualToString:@"SHARE"]) {
                shift = -500.0;
            }   else {
                shift = 600.0 - node.position.y;
            }
            if ([node.name isEqualToString:@"NEW_GAME"]) {
                shift = -170.0;
            }
            SKAction *goAway = [SKAction moveByX:0.0 y:shift duration:DISAPEAR_DURATION/1.5];
            if ([node.name isEqualToString:@"NEW_GAME"]) {
                [node runAction:goAway];
            } else{
                SKAction *sequence = [SKAction sequence:@[goAway, [SKAction removeFromParent]]];
                [node runAction:sequence completion:^{
                    if (self.children.count == 1) {
                        //Present new Scene;
                        ShareScene *scene = [[ShareScene alloc] initWithSize:self.size];
                        scene.scaleMode = SKSceneScaleModeAspectFill;
                        scene.score = self.score;
                        [self.view presentScene:scene];
                    }
                }];
            }
        }
    }

    
    if(!self.peter.physicsBody.affectedByGravity){
        [self.peter.physicsBody setAffectedByGravity:YES];
        [self drawScore];
        [self.peter runAction:[SKAction rotateByAngle:M_PI/8 duration:ROTATION_DURATION/2]];
        self.peterAngle=M_PI/8;
    }
    
    
    if(self.peter.physicsBody.velocity.dy>0){
        [self.peter.physicsBody applyImpulse:CGVectorMake(0, VELOCITY_TO_ADD)];
    }else{
        [self.peter.physicsBody applyImpulse:CGVectorMake(0, -self.peter.physicsBody.velocity.dy+VELOCITY_TO_ADD)];
    }

    
    
}

-(void)rotatePeter{
    if(self.peterFalls && self.peterAngle>0){
        [self.peter runAction:[SKAction rotateByAngle:-M_PI/4 duration:ROTATION_DURATION]];
        self.peterAngle=-M_PI/8;
    }else{
        if(!self.peterFalls && self.peterAngle<0){
            [self.peter runAction:[SKAction rotateByAngle:M_PI/4 duration:ROTATION_DURATION]];
            self.peterAngle=M_PI/8;
        }
    }
}

-(void)checkPeterPosition{
    if(self.peter.position.y>500 && self.peter.physicsBody.velocity.dy>0){
        CGVector vector=CGVectorMake(0, -self.peter.physicsBody.velocity.dy);
        [self.peter.physicsBody applyImpulse:vector];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    self.scoreLabel.text=[NSString stringWithFormat: @"%d", (int)self.score];
    for(int index=0; index< self.arrayOfColumns.count; index++){
        SKSpriteNode *node=self.arrayOfColumns[index];
        if(node.position.x<=0){
            if([node.name isEqualToString:@"T_COLUMN"]){
                node.name=@"COLUMN_GONE";
                [self.arrayOfColumns removeObjectAtIndex:index];
            }else{
                node.name=@"COLUMN_GONE";
                self.score++;
                [self.arrayOfColumns removeObjectAtIndex:index];
            }
        }
    }
    if(self.peter.physicsBody.velocity.dy<0){
        self.peterFalls=YES;
        [self rotatePeter];
    }else{
        if(self.peter.physicsBody.velocity.dy>0){
            self.peterFalls=NO;
            [self rotatePeter];
        }
    }
    [self checkPeterPosition];

}

@end
