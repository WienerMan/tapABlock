//
//  HomeViewController.m
//  Tap Madness
//
//  Created by Ryan Wiener on 1/5/16.
//  Copyright © 2016 Ryan Wiener. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    int width;
    int height;
    int prob;
    int x;
    int y;
    int lastprob;
    UIView *view;
    UIImageView *background;
    CGRect viewFrame;
    NSTimer *timer;
    bool ad;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ad = YES;
    lastprob = 8;
    background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"Tap A Block Background.png"];
    background.alpha = .5;
    [self.view addSubview:background];
    _leaderboard = [UIButton buttonWithType:UIButtonTypeSystem];
    _leaderboard.frame = CGRectMake(0, self.view.bounds.size.height / 8, self.view.bounds.size.width / 3, self.view.bounds.size.height / 8);
    [_leaderboard addTarget:self action:@selector(loadLeaderboard:) forControlEvents:UIControlEventTouchUpInside];
    [_leaderboard setTitle:@"Leaderboard"
                        forState:UIControlStateNormal];
    _leaderboard.titleLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 10];
    [_leaderboard setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    _leaderboard.titleLabel.adjustsFontSizeToFitWidth = YES;
    _name = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 5, self.view.bounds.size.width / 2, self.view.bounds.size.height / 4)];
    _name.font = [UIFont systemFontOfSize:self.view.bounds.size.width / 14 weight:10];
    _name.text = @"Tap A Block";
    _name.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_name.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 4)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 2)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(6, 5)];
    _name.attributedText = string;
    [self.view addSubview:_name];
    _tapContinue = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, 9 * self.view.bounds.size.height / 20, self.view.bounds.size.width / 2, self.view.bounds.size.height / 6)];
    _tapContinue.font = [UIFont systemFontOfSize:40];
    _tapContinue.textColor = [UIColor whiteColor];
    _tapContinue.text = @"Tap to Begin";
    _tapContinue.textAlignment = NSTextAlignmentCenter;
    _tapContinue.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_tapContinue];
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    _bannerView.frame = CGRectMake(0, self.view.bounds.size.height - _bannerView.bounds.size.height, self.view.bounds.size.width, _bannerView.bounds.size.height);
    // test
    _bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    // real
    //_bannerView.adUnitID = @"ca-app-pub-8340709037043335/8530819008";
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    [_bannerView loadRequest:[GADRequest request]];
    [self.view addSubview:_bannerView];
    timer = [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(createBlocks:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    if (_blocks == nil)
        _blocks = [[NSMutableArray alloc] init];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"FAILURE RECEIVING AD: %@", [error localizedDescription]);
    ad = NO;
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    NSLog(@"RECEIVED");
    ad = YES;
}

- (IBAction)loadLeaderboard:(id)sender
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createBlocks:(id)sender
{
        width = arc4random_uniform(11) + self.view.bounds.size.width / 9;
        height = arc4random_uniform(11) + self.view.bounds.size.width / 9;
        prob = arc4random_uniform(4);
        while (lastprob == prob)
            prob = arc4random_uniform(4);
        lastprob = prob;
        if (prob == 0)
        {
            x = arc4random_uniform(self.view.bounds.size.width / 4 - width) + 3 * self.view.bounds.size.width / 4;
            y = -height;
        }
        else if (prob == 1)
        {
            x = arc4random_uniform(self.view.bounds.size.width / 4 - width) + 3 * self.view.bounds.size.width / 4;
            y = self.view.bounds.size.height;
        }
        else if (prob == 2)
        {
            x = -width;
            if (ad)
            {
                y = arc4random_uniform(self.view.bounds.size.height - _tapContinue.bounds.size.height - _tapContinue.frame.origin.y - height - _bannerView.bounds.size.height) + _tapContinue.bounds.size.height + _tapContinue.frame.origin.y;
            }
            else
            {
                y = arc4random_uniform(self.view.bounds.size.height - _tapContinue.bounds.size.height - _tapContinue.frame.origin.y - height) + _tapContinue.bounds.size.height + _tapContinue.frame.origin.y;
            }
        }
        else if (prob == 3)
        {
            x = self.view.bounds.size.width;
            if (ad)
            {
                y = arc4random_uniform(self.view.bounds.size.height - _tapContinue.bounds.size.height - _tapContinue.frame.origin.y - height - _bannerView.bounds.size.height) + _tapContinue.bounds.size.height + _tapContinue.frame.origin.y;
            }
            else
            {
                y = arc4random_uniform(self.view.bounds.size.height - _tapContinue.bounds.size.height - _tapContinue.frame.origin.y - height) + _tapContinue.bounds.size.height + _tapContinue.frame.origin.y;
            }
        }
        view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        view.layer.cornerRadius = 7.5;
        view.layer.masksToBounds = YES;
        prob = arc4random_uniform(3);
        if (prob == 0)
            view.backgroundColor = [UIColor greenColor];
        else if (prob == 1)
            view.backgroundColor = [UIColor redColor];
        else
            view.backgroundColor = [UIColor blueColor];
        [self.view addSubview:view];
        [self.view sendSubviewToBack:view];
        [self.view sendSubviewToBack:background];
        [_blocks addObject:view];
        [UIView animateWithDuration:5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveLinear
                         animations:^{
                             if (x == -width)
                                 view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width + width, 0);
                             else if (x == self.view.bounds.size.width)
                                 view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width - width, 0);
                             else if (y == -height)
                                 view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height + height);
                             else
                                 view.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height - height);}
                         completion:^(BOOL finished){
                             if (finished)
                             {
                                 [[_blocks firstObject] removeFromSuperview];
                                 [_blocks removeObjectAtIndex:0];
                             }
                         }];
}

@end