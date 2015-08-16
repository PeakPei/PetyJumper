//
//  AppDelegate.h
//  PetyJumper1
//
//  Created by Sosnovik on 16.08.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>{
    AVAudioPlayer *player;
}

@property (strong, nonatomic) UIWindow *window;


@end

