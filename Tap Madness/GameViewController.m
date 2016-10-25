//
//  GameViewController.m
//  Tap Madness
//
//  Created by Ryan Wiener on 12/5/15.
//  Copyright © 2015 Ryan Wiener. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"

@interface GameViewController ()

@end

@implementation GameViewController
{
    int width;
    int height;
    int prob;
    int x;
    int y;
    int count;
    int taps;
    int tag;
    int milisecs;
    int lastprob;
    bool ad;
    UILabel *countDownLabel;
    UILabel *seconds;
    UILabel *colon;
    UILabel *minutes;
    UILabel *scoreLabel;
    UILabel *score;
    UILabel *accuracyLabel;
    UILabel *accuracy;
    UILabel *reasonLost;
    UIView *view;
    UIButton *restartButton;
    UIButton *returnButton;
    UITapGestureRecognizer *tapRecognizer;
    CGRect viewFrame;
    NSTimer *timer1;
    NSTimer *timer2;
    NSTimer *timer3;
    UIImageView *background;
    NSMutableArray *createdTime;
    NSNumber *secs;
    NSString *leaderboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    milisecs = 0;
    count = 0;
    lastprob = 7;
    ad = NO;
    background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"Tap A Block Background.png"];
    background.alpha = .5;
    [self.view addSubview:background];
    countDownLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.text = @"3";
    countDownLabel.textColor = [UIColor whiteColor];
    countDownLabel.font = [UIFont systemFontOfSize:80];
    [self.view addSubview:countDownLabel];
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
    _bannerView.frame = CGRectMake(0, self.view.bounds.size.height - _bannerView.bounds.size.height, self.view.bounds.size.width, _bannerView.bounds.size.height);
    // test
    _bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    // real
    //_bannerView.adUnitID = @"ca-app-pub-8340709037043335/1007552202";
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    [_bannerView loadRequest:[GADRequest request]];
    [self.view addSubview:_bannerView];
    timer1 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    AudioServicesPlaySystemSound (1201);
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"FAILURE RECEIVING AD: %@", [error localizedDescription]);
    ad = NO;
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    NSLog(@"RECEIVED");
    ad = YES;
}

- (IBAction)countDown:(NSTimer*)timer
{
    if ([countDownLabel.text integerValue] > 1)
    {
        AudioServicesPlaySystemSound (1201);
        countDownLabel.text = [NSString stringWithFormat:@"%d", [countDownLabel.text intValue] - 1];
    }
    else
    {
        AudioServicesPlaySystemSound (1101);
        /*
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/My Song.m4a",
                                   [[NSBundle mainBundle] resourcePath]];
        NSLog(@"%@", soundFilePath);
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        */
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *myFile = [mainBundle pathForResource: @"My Song" ofType: @"m4a"];
        NSLog(@"%@", myFile);
        NSURL *audioFileURL = [NSURL URLWithString:myFile];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL
                                                                       error:nil];
        player.numberOfLoops = -1; //Infinite
        
        [player play];
        [countDownLabel removeFromSuperview];
        countDownLabel = nil;
        [timer1 invalidate];
        timer1 = nil;
        taps = 0;
        timer2 = [NSTimer timerWithTimeInterval:.001 target:self selector:@selector(timeElapsed:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
        timer3 = [NSTimer timerWithTimeInterval:.4 target:self selector:@selector(createBlocks:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSDefaultRunLoopMode];
        if (scoreLabel == nil)
        {
            scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3 * self.view.bounds.size.width / 20, self.view.bounds.size.height / 14)];
            scoreLabel.text = @"Score";
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            scoreLabel.textColor = [UIColor whiteColor];
            scoreLabel.font = [UIFont systemFontOfSize:30];
            scoreLabel.adjustsFontSizeToFitWidth = YES;
        }
        [self.view addSubview:scoreLabel];
        if (score == nil)
        {
            score = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 15, 3 * self.view.bounds.size.width / 20, self.view.bounds.size.height / 10)];
            score.textColor = [UIColor whiteColor];
            score.textAlignment = NSTextAlignmentCenter;
            score.font = [UIFont systemFontOfSize:30];
            score.adjustsFontSizeToFitWidth = YES;
        }
        [self.view addSubview:score];
        score.text = @"0";
        if (accuracyLabel == nil)
        {
            accuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(33 * self.view.bounds.size.width / 40, 0, 7 * self.view.bounds.size.width / 40, self.view.bounds.size.height / 10)];
            accuracyLabel.text = @"Accuracy";
            accuracyLabel.textColor = [UIColor whiteColor];
            accuracyLabel.font = [UIFont systemFontOfSize:30];
            accuracyLabel.adjustsFontSizeToFitWidth = YES;
        }
        [self.view addSubview:accuracyLabel];
        if (accuracy == nil)
        {
            accuracy = [[UILabel alloc] initWithFrame:CGRectMake(33 * self.view.bounds.size.width / 40, self.view.bounds.size.height / 13, 7 * self.view.bounds.size.width / 40, self.view.bounds.size.height / 10)];
            accuracy.textColor = [UIColor whiteColor];
            accuracy.textAlignment = NSTextAlignmentCenter;
            accuracy.font = [UIFont systemFontOfSize:30];
            accuracy.adjustsFontSizeToFitWidth = YES;
        }
        [self.view addSubview:accuracy];
        accuracy.text = @"0%";
        if (colon == nil)
        {
            colon = [[UILabel alloc] initWithFrame:CGRectMake(49 * self.view.bounds.size.width / 100, self.view.bounds.size.height / 16, self.view.bounds.size.width / 50, self.view.bounds.size.height / 10)];
            colon.text = @":";
            colon.textColor = [UIColor whiteColor];
            colon.textAlignment = NSTextAlignmentCenter;
            colon.font = [UIFont systemFontOfSize:40];
            colon.adjustsFontSizeToFitWidth = YES;
        }
        [self.view addSubview:colon];
        if (seconds == nil)
        {
            seconds = [[UILabel alloc] initWithFrame:CGRectMake(51 * self.view.bounds.size.width / 100, 3 * self.view.bounds.size.height / 40, 3 * self.view.bounds.size.height / 20, self.view.bounds.size.height / 10)];
            seconds.textColor = [UIColor whiteColor];
            seconds.textAlignment = NSTextAlignmentLeft;
            seconds.font = [UIFont systemFontOfSize:40];
            seconds.adjustsFontSizeToFitWidth = YES;
        }
        seconds.text = @"00";
        [self.view addSubview:seconds];
        if (minutes == nil)
        {
            minutes = [[UILabel alloc] initWithFrame:CGRectMake(49 * self.view.bounds.size.width / 100 - 3 * self.view.bounds.size.height / 20, 3 * self.view.bounds.size.height / 40, 3 * self.view.bounds.size.height / 20, self.view.bounds.size.height / 10)];
            minutes.textColor = [UIColor whiteColor];
            minutes.textAlignment = NSTextAlignmentRight;
            minutes.font = [UIFont systemFontOfSize:40];
            minutes.adjustsFontSizeToFitWidth = YES;
        }
        minutes.text = @"00";
        [self.view addSubview:minutes];
        if (_pause == nil)
            _pause = [UIButton buttonWithType:UIButtonTypeSystem];
        _pause.frame = CGRectMake(49 * self.view.bounds.size.width / 100 - 3 * self.view.bounds.size.height / 20, 0, 3 * self.view.bounds.size.height / 10 + self.view.bounds.size.width / 50, 3 * self.view.bounds.size.height / 40);
        _pause.titleLabel.font = [UIFont systemFontOfSize:30];
        _pause.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_pause];
        [_pause setTitle:@"Pause"
               forState:UIControlStateNormal];
        [_pause removeTarget:self action:@selector(resumeGame:) forControlEvents:UIControlEventTouchUpInside];
        [_pause addTarget:self
                  action:@selector(pauseGame:)
        forControlEvents:UIControlEventTouchUpInside];
        if (_blocks == nil)
            _blocks = [[NSMutableArray alloc] init];
        if (tapRecognizer == nil)
        {
            tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self.view addGestureRecognizer:tapRecognizer];
        }
        if (createdTime == nil)
            createdTime = [[NSMutableArray alloc] init];
    }
}

- (IBAction)pauseGame:(id)sender
{
    if (timer3 == nil)
    {
        [timer1 invalidate];
        timer1 = nil;
    }
    else
    {
        for (UIView *block in _blocks)
                [UIView animateWithDuration:1
                                 animations:^{block.alpha = .5;}];
            [timer2 invalidate];
            [timer3 invalidate];
            timer3 = nil;
            for (UIView *block in _blocks)
            {
                viewFrame = [block.layer.presentationLayer frame];
                [block.layer removeAllAnimations];
                block.transform = CGAffineTransformIdentity;
                block.frame = viewFrame;
            }
            view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4, self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
            view.backgroundColor = [UIColor whiteColor];
            restartButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [restartButton addTarget:self action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
            restartButton.frame = CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4 + self.view.bounds.size.height / 6, self.view.bounds.size.width / 2, self.view.bounds.size.height / 6);
            restartButton.titleLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 12];
            [restartButton setTitle:@"Restart"
                           forState:UIControlStateNormal];
            returnButton = [AppDelegate getReturnButton];
            returnButton.frame = CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4 + self.view.bounds.size.height / 3, self.view.bounds.size.width / 2, self.view.bounds.size.height / 6);
            returnButton.titleLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 12];
            [returnButton setTitleColor:returnButton.tintColor forState:UIControlStateNormal];
            [self.view addSubview:view];
            [self.view addSubview:restartButton];
            [self.view addSubview:returnButton];
            [self.view bringSubviewToFront:_pause];
            [self.view.layer removeAllAnimations];
            [_pause setTitle:@"Resume"
               forState:UIControlStateNormal];
            [_pause removeTarget:self action:@selector(pauseGame:) forControlEvents:UIControlEventTouchUpInside];
            [_pause addTarget:self
                  action:@selector(resumeGame:)
             forControlEvents:UIControlEventTouchUpInside];
            _pause.frame = CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4, self.view.bounds.size.width / 2, self.view.bounds.size.height / 6);
            _pause.titleLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 12];
    }
}

- (IBAction)resumeGame:(id)sender
{
    for (UIView *block in _blocks)
        block.alpha = 1;
    if (countDownLabel != nil)
    {
        timer1 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
        AudioServicesPlayAlertSound (1201);
    }
    else
    {
        [view removeFromSuperview];
        [restartButton removeFromSuperview];
        [returnButton removeFromSuperview];
        [_pause setTitle:@"Pause"
               forState:UIControlStateNormal];
        [_pause removeTarget:self action:@selector(resumeGame:) forControlEvents:UIControlEventTouchUpInside];
        [_pause addTarget:self
                  action:@selector(pauseGame:)
         forControlEvents:UIControlEventTouchUpInside];
        _pause.frame = CGRectMake(49 * self.view.bounds.size.width / 100 - 3 * self.view.bounds.size.height / 20, 0, 3 * self.view.bounds.size.height / 10 + self.view.bounds.size.width / 50, 3 * self.view.bounds.size.height / 40);
        _pause.titleLabel.font = [UIFont systemFontOfSize:30];
        timer3 = [NSTimer timerWithTimeInterval:1 / (2.0 * count + 7) + .25 target:self selector:@selector(createBlocks:) userInfo:nil repeats:YES];
        for (UIView *block in _blocks)
        {
            secs = [createdTime objectAtIndex:[_blocks indexOfObject:block]];
            [UIView animateWithDuration:(count + 10) * timer3.timeInterval - (60 * [minutes.text integerValue] + [seconds.text integerValue] + milisecs / 1000.0 - secs.doubleValue)
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveLinear
                             animations:^{
                                 if (block.tag == 1)
                                     block.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width - block.frame.origin.x, 0);
                                 else if (block.tag == 2)
                                     block.transform = CGAffineTransformMakeTranslation(-block.frame.origin.x - block.frame.size.width, 0);
                                 else if (block.tag == 3)
                                     if (ad)
                                     {
                                         block.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height - block.frame.origin.y - _bannerView.bounds.size.height);
                                     }
                                     else
                                     {
                                         block.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height - block.frame.origin.y);
                                     }
                                 else if (block.tag == 4)
                                     block.transform = CGAffineTransformMakeTranslation(0, -block.frame.origin.y - block.frame.size.height);}
                             completion:^(BOOL finished){
                                 if (finished == YES)
                                 {
                                     view = [_blocks firstObject];
                                     if ([view.backgroundColor isEqual:[UIColor redColor]])
                                     {
                                         [createdTime removeObjectAtIndex:0];
                                         [view removeFromSuperview];
                                         [_blocks removeObjectAtIndex:0];
                                     }
                                     else if ([view.backgroundColor isEqual:[UIColor greenColor]])
                                     {
                                         [self terminateGame:@"green"];
                                     }
                                     else if ([view.backgroundColor isEqual:[UIColor blueColor]])
                                     {
                                         [self terminateGame:@"blue"];
                                     }
                                 }
                             }];
        }
        timer2 = [NSTimer timerWithTimeInterval:.001 target:self selector:@selector(timeElapsed:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSDefaultRunLoopMode];
    }
}

- (IBAction)timeElapsed:(NSTimer*)timer
{
    milisecs++;
    if (milisecs == 1000)
    {
        milisecs = 0;
        if ([seconds.text integerValue] == 59)
        {
            minutes.text = minutes.text = [NSString stringWithFormat:@"%d", [minutes.text intValue] + 1];
            if ([minutes.text length] < 2)
                minutes.text = [@"0" stringByAppendingString:minutes.text];
            seconds.text = @"00";
        }
        else
        {
            seconds.text = seconds.text = [NSString stringWithFormat:@"%d", [seconds.text intValue] + 1];
            if ([seconds.text length] < 2)
                seconds.text = [@"0" stringByAppendingString:seconds.text];
        }
        if ([seconds.text integerValue] % 15 == 0)
        {
            count++;
            [timer3 invalidate];
            timer3 = [NSTimer timerWithTimeInterval:1 / (2.0 * count + 7) + .25 target:self selector:@selector(createBlocks:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSDefaultRunLoopMode];
        }
    }
}

- (IBAction)createBlocks:(id)sender
{
    width = arc4random_uniform(11) + self.view.bounds.size.width / 8;
    height = arc4random_uniform(11) + self.view.bounds.size.width / 8;
    prob = arc4random_uniform(6);
    while (lastprob == prob)
        prob = arc4random_uniform(6);
    lastprob = prob;
    if (prob == 0)
    {
        x = -width;
        if (ad)
        {
            y = arc4random_uniform(self.view.bounds.size.height - height - _pause.bounds.size.height - seconds.bounds.size.height - _bannerView.bounds.size.height) + _pause.bounds.size.height + seconds.bounds.size.height;
        }
        else
        {
            y = arc4random_uniform(self.view.bounds.size.height - height - _pause.bounds.size.height - seconds.bounds.size.height) + _pause.bounds.size.height + seconds.bounds.size.height;
        }
        tag = 1;
    }
    else if (prob == 1)
    {
        x = arc4random_uniform(49 * self.view.bounds.size.width / 100 - 3 * self.view.bounds.size.height / 20 - width - scoreLabel.bounds.size.width) + scoreLabel.bounds.size.width;
        y = -height;
        tag = 3;
    }
    else if (prob == 2)
    {
        x = arc4random_uniform(33 * self.view.bounds.size.width / 40 - seconds.bounds.size.width - 51 * self.view.bounds.size.width / 100 - width) + seconds.bounds.size.width + 51 * self.view.bounds.size.width / 100;
        y = -height;
        tag = 3;
    }
    else if (prob == 3)
    {
        x = self.view.bounds.size.width;
        if (ad)
        {
            y = arc4random_uniform(self.view.bounds.size.height - height - _pause.bounds.size.height - seconds.bounds.size.height - _bannerView.bounds.size.height) + _pause.bounds.size.height + seconds.bounds.size.height;
        }
        else
        {
            y = arc4random_uniform(self.view.bounds.size.height - height - _pause.bounds.size.height - seconds.bounds.size.height) + _pause.bounds.size.height + seconds.bounds.size.height;
        }
        tag = 2;
    }
    else if (prob == 4)
    {
        x = arc4random_uniform(33 * self.view.bounds.size.width / 40 - seconds.bounds.size.width - 51 * self.view.bounds.size.width / 100 - width) + seconds.bounds.size.width + 51 * self.view.bounds.size.width / 100;
        y = self.view.bounds.size.height;
        tag = 4;
    }
    else
    {
        x = arc4random_uniform(49 * self.view.bounds.size.width / 100 - 3 * self.view.bounds.size.height / 20 - width - scoreLabel.bounds.size.width) + scoreLabel.bounds.size.width;
        y = self.view.bounds.size.height;
        tag = 4;
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    view.tag = tag;
    view.layer.cornerRadius = 7.5;
    view.layer.masksToBounds = YES;
    prob = arc4random_uniform(5 + 6 * count / 5);
    if (prob <= 4 + count / 5)
        view.backgroundColor = [UIColor greenColor];
    else if (prob <= 5 + 2 * count / 5)
        view.backgroundColor = [UIColor redColor];
    else
        view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    [self.view sendSubviewToBack:background];
    [_blocks addObject:view];
    [createdTime addObject:[NSNumber numberWithDouble:60 * [minutes.text integerValue] + [seconds.text integerValue] + milisecs / 1000.0]];
    [UIView animateWithDuration:(count + 10) * timer3.timeInterval
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (x == -width)
                             view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width + width, 0);
                         else if (x == self.view.bounds.size.width)
                             view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width - width, 0);
                         else if (y == -height)
                             if (ad)
                             {
                                 view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height + height - _bannerView.bounds.size.height);
                             }
                             else
                             {
                                 view.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height + height);
                             }
                         else
                             view.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height - height);}
                     completion:^(BOOL finished){
                         if (finished == YES)
                         {
                            view = [_blocks firstObject];
                                if ([view.backgroundColor isEqual:[UIColor redColor]])
                                {
                                    [createdTime removeObjectAtIndex:0];
                                    [view removeFromSuperview];
                                    [_blocks removeObjectAtIndex:0];
                                }
                                else if ([view.backgroundColor isEqual:[UIColor greenColor]])
                                {
                                    [self terminateGame:@"green"];
                                }
                                else if ([view.backgroundColor isEqual:[UIColor blueColor]])
                                {
                                    [self terminateGame:@"blue"];
                                }
                            }
                        }];
}

- (IBAction)restartGame:(id)sender
{
    count = 0;
    for (UIView *subview in self.view.subviews)
    {
        view = subview;
        view.alpha = 1;
        [view removeFromSuperview];
        [_blocks removeObject:view];
        view = nil;
    }
    background.alpha = .5;
    [self.view addSubview:background];
    countDownLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.text = @"3";
    countDownLabel.textColor = [UIColor whiteColor];
    countDownLabel.font = [UIFont systemFontOfSize:80];
    [self.view addSubview:countDownLabel];
    [self.view addSubview:_bannerView];
    timer1 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    AudioServicesPlaySystemSound(1201);
}

- (void)terminateGame:(NSString*)color
{
    AudioServicesPlaySystemSound (1100);
    [timer3 invalidate];
    [timer2 invalidate];
    for (UIView *block in _blocks)
    {
        viewFrame = [block.layer.presentationLayer frame];
        [block.layer removeAllAnimations];
        block.transform = CGAffineTransformIdentity;
        block.frame = viewFrame;
    }
    [_pause removeFromSuperview];
    [createdTime removeAllObjects];
    reasonLost = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4, self.view.bounds.size.width / 2, self.view.bounds.size.height / 6)];
    if ([color isEqual:@"red"])
        reasonLost.text = [NSString stringWithFormat:@"Don't tap the %@ blocks!", color];
    else
        reasonLost.text = [NSString stringWithFormat:@"Don't let the %@ blocks reach the other side!", color];
    if ([AppDelegate gameCenterEnabled])
    {
        [self reportScore];
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        gcViewController.gameCenterDelegate = self;
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gcViewController animated:YES completion:nil];
    }
    else
    {
        [self pauseGame:color];
        reasonLost.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 17 weight:5];
        reasonLost.textAlignment = NSTextAlignmentCenter;
        reasonLost.lineBreakMode = NSLineBreakByWordWrapping;
        reasonLost.numberOfLines = 0;
        [self.view addSubview:reasonLost];
    }
}

- (void)handleTap:(UITapGestureRecognizer*)sender
{
    if (timer3 != nil)
    {
        for (int ind = 0; ind < (int)_blocks.count; ind++)
        {
            view = [_blocks objectAtIndex:ind];
            viewFrame = [view.layer.presentationLayer frame];
            if (CGRectContainsPoint(viewFrame, [sender locationInView:self.view]))
            {
                if ([view.backgroundColor isEqual:[UIColor greenColor]])
                {
                    [createdTime removeObjectAtIndex:[_blocks indexOfObject:view]];
                    AudioServicesPlaySystemSound (1103);
                    score.text = score.text = [NSString stringWithFormat:@"%d", [score.text intValue] + 1];
                    while (ind > 0)
                    {
                        [_blocks exchangeObjectAtIndex:ind withObjectAtIndex:ind - 1];
                        ind--;
                    }
                    [_blocks removeObjectAtIndex:0];
                    [view removeFromSuperview];
                    view = nil;
                }
                else if ([view.backgroundColor isEqual:[UIColor redColor]])
                {
                    [self terminateGame:@"red"];
                }
                else if ([view.backgroundColor isEqual:[UIColor blueColor]])
                {
                    AudioServicesPlaySystemSound (1103);
                    score.text = score.text = [NSString stringWithFormat:@"%d", [score.text intValue] + 1];
                    prob = arc4random_uniform(2);
                    if (prob == 0)
                        view.backgroundColor = [UIColor greenColor];
                    else
                        view.backgroundColor = [UIColor redColor];
                }
                view = nil;
                break;
            }
        }
        taps++;
        accuracy.text = [[NSString stringWithFormat:@"%d", (int)(100 * [score.text doubleValue] / taps)] stringByAppendingString:@"%"];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    [self pauseGame:gameCenterViewController];
    reasonLost.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 17 weight:5];
    reasonLost.textAlignment = NSTextAlignmentCenter;
    reasonLost.lineBreakMode = NSLineBreakByWordWrapping;
    reasonLost.numberOfLines = 0;
    [self.view addSubview:reasonLost];
}

-(void)reportScore{
    GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"21"];
    gkScore.value = [score.text intValue];
    GKScore *gkTime = [[GKScore alloc] initWithLeaderboardIdentifier:@"22"];
    gkTime.value = [minutes.text intValue] * 60 + [seconds.text intValue];
    GKScore *gkAccuracy = [[GKScore alloc] initWithLeaderboardIdentifier:@"23"];
    gkAccuracy.value = (int)(100 * [score.text doubleValue] / taps);
    GKScore *gkAccurScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"24"];
    gkAccurScore.value = (int)([score.text intValue] * [score.text doubleValue] / taps);
    [GKScore reportScores:@[gkScore, gkTime, gkAccuracy, gkAccurScore] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end