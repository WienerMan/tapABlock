//
//  AppDelegate.m
//  Tap Madness
//
//  Created by Ryan Wiener on 12/5/15.
//  Copyright © 2015 Ryan Wiener. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    UIButton *sender;
    UIButton *instructionsButton;
    UITapGestureRecognizer *tapRecognizer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self authenticateLocalPlayer];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _homeViewController = [[HomeViewController alloc] init];
    [_window setRootViewController:_homeViewController];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_window.rootViewController.view addGestureRecognizer:tapRecognizer];
    [_window makeKeyAndVisible];
    returnHome = [UIButton buttonWithType:UIButtonTypeSystem];
    [returnHome addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    [returnHome setTitle:@"Return to Menu" forState:UIControlStateNormal];
    returnHome.titleLabel.adjustsFontSizeToFitWidth = YES;
    instructionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    instructionsButton.frame = CGRectMake(0, 0, _window.rootViewController.view.bounds.size.width / 3, _window.rootViewController.view.bounds.size.height / 8);
    [instructionsButton addTarget:self action:@selector(instructions:) forControlEvents:UIControlEventTouchUpInside];
    [instructionsButton setTitle:@"Instructions"
                forState:UIControlStateNormal];
    instructionsButton.titleLabel.font = [UIFont systemFontOfSize:_window.rootViewController.view.bounds.size.height / 10];
    [instructionsButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    instructionsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_window.rootViewController.view addSubview:instructionsButton];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource: @"My Song" ofType: @"m4a"];
    NSLog(@"%@", myFile);
    NSError *error;
    NSURL *audioFileURL = [NSURL URLWithString:myFile];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL
                                                                   error:&error];
    _player.numberOfLoops = -1; //Infinite
    NSLog(@"%@",[error localizedDescription]);
    bool played = [_player play];
    NSLog(@"%@", played ? @"Yes" : @"No");
    return YES;
}

- (IBAction)instructions:(id)sender
{
    _homeViewController = nil;
    _instructionsViewController = [[InstructionsViewController alloc] init];
    returnHome.frame = CGRectMake(0, 0, 2 * _window.rootViewController.view.bounds.size.width / 5, _window.rootViewController.view.bounds.size.height / 5);
    returnHome.titleLabel.font = [UIFont systemFontOfSize:_window.rootViewController.view.bounds.size.height / 10];
    [returnHome setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_window setRootViewController:_instructionsViewController];
    [_window.rootViewController.view addSubview:returnHome];
}

+ (UIButton*)getReturnButton
{
    return returnHome;
}
     
- (IBAction)returnHome:(id)sender
{
    _gameViewController = nil;
    _instructionsViewController = nil;
    _homeViewController = [[HomeViewController alloc] init];
    [_window setRootViewController:_homeViewController];
    [_window.rootViewController.view addGestureRecognizer:tapRecognizer];
    [_window.rootViewController.view addSubview:instructionsButton];
    if (gameCenterEnabled)
        [_homeViewController.view addSubview:_homeViewController.leaderboard];
    [_window.rootViewController.view addGestureRecognizer:tapRecognizer];
}

- (IBAction)handleTap:(id)sender
{
    _homeViewController = nil;
    _gameViewController = [[GameViewController alloc] init];
    [_window setRootViewController:_gameViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if (_gameViewController != nil)
        [_gameViewController pauseGame:sender];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_gameViewController != nil)
        [_gameViewController pauseGame:sender];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (_gameViewController != nil)
        [_gameViewController pauseGame:sender];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_gameViewController != nil)
        if (_gameViewController.pause == nil)
            [_gameViewController resumeGame:sender];
}

+ (BOOL)gameCenterEnabled
{
    return gameCenterEnabled;
}

- (void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
        else if (viewController != nil) {
            [_window.rootViewController presentViewController:viewController animated:YES completion:nil];
        }
        gameCenterEnabled = [GKLocalPlayer localPlayer].authenticated;
        if (gameCenterEnabled)
        {
            [_homeViewController.view addSubview:_homeViewController.leaderboard];
        }
    };
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end