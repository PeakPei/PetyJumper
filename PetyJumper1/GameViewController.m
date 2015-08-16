//
//  GameViewController.m
//  PetyJumper
//
//  Created by Sosnovik on 02.03.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Colors.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passedTutorial = NO;
    self.view.window.backgroundColor = [Colors waterColor];
    //   self.view.backgroundColor = [Colors waterColor];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.passedTutorial) {
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        //Google ad
//        self.banner.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
//        self.banner.rootViewController = self;
//        [self.banner loadRequest:[GADRequest request]];
        
        
        // Create and configure the scene.
        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        
        // Present the scene.
        [skView presentScene:scene];
    };
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.passedTutorial) {
        self.passedTutorial = YES;
        [self performSegueWithIdentifier:@"showTutorial" sender:self];
    }
    
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}





@end
