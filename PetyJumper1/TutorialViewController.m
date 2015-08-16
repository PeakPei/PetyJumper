//
//  TutorialViewController.m
//  PetyJumper
//
//  Created by Sosnovik on 05.08.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "TutorialViewController.h"
#import "Colors.h"

@interface TutorialViewController ()


@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Colors waterColor];
    self.palmImageView.alpha = 0.0;
    // Do any additional setup after loading the view.
}



- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        //
        self.palmImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self makeImageSmaller];
    }];
}

-(void)makeImageSmaller{
//    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        //
        self.palmHeight.constant -=20.0;
        self.palmWidth.constant -=20.0;
        self.dolphinY.constant +=90.0;
        self.dolphinImageView.transform = CGAffineTransformMakeRotation(-M_PI/24);
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self makeImageBigger];
    }];
    
}
-(void)makeImageBigger{
//    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        //
        self.palmHeight.constant +=20.0;
        self.palmWidth.constant +=20.0;
        self.dolphinY.constant -=90.0;
        self.dolphinImageView.transform = CGAffineTransformMakeRotation(M_PI/12);
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self makeImageSmaller];
    }];
    
}




@end
