//
//  AppDelegate.h
//  Tap Madness
//
//  Created by Ryan Wiener on 12/5/15.
//  Copyright © 2015 Ryan Wiener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "HomeViewController.h"
#import "GameViewController.h"
#import "InstructionsViewController.h"

static UIButton *returnHome;
static bool gameCenterEnabled;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) GameViewController *gameViewController;
@property (nonatomic) HomeViewController *homeViewController;
@property (nonatomic) InstructionsViewController *instructionsViewController;
@property (nonatomic, strong) AVAudioPlayer *player;
+ (UIButton*)getReturnButton;
+ (BOOL)gameCenterEnabled;

@end