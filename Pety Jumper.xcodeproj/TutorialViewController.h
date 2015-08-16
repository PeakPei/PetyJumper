//
//  TutorialViewController.h
//  PetyJumper
//
//  Created by Sosnovik on 05.08.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController 
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *palmHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *palmWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dolphinY;
@property (strong, nonatomic) IBOutlet UIImageView *dolphinImageView;
@property (strong, nonatomic) IBOutlet UIImageView *palmImageView;

@end
