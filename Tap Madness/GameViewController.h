//
//  GameViewController.h
//  Tap Madness
//
//  Created by Ryan Wiener on 12/5/15.
//  Copyright © 2015 Ryan Wiener. All rights reserved.
//

@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface GameViewController : UIViewController <GKGameCenterControllerDelegate, GADBannerViewDelegate>

@property (nonatomic) NSMutableArray *blocks;
@property (nonatomic) UIButton *pause;
- (IBAction)pauseGame:(id)sender;
- (IBAction)resumeGame:(id)sender;
@property (nonatomic) IBOutlet GADBannerView *bannerView;

@end