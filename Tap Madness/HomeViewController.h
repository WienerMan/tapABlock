//
//  HomeViewController.h
//  Tap Madness
//
//  Created by Ryan Wiener on 1/5/16.
//  Copyright © 2016 Ryan Wiener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<GameKit/GameKit.h>
@import GoogleMobileAds;

#ifndef HomeViewController_h
#define HomeViewController_h

@interface HomeViewController : UIViewController <GKGameCenterControllerDelegate, GADBannerViewDelegate>

@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *tapContinue;
@property (nonatomic) NSMutableArray *blocks;
@property (nonatomic) UIButton *leaderboard;
@property (nonatomic)  IBOutlet GADBannerView *bannerView;

@end

#endif /* HomeViewController_h */