//
//  InstructionsViewController.m
//  Tap Madness
//
//  Created by Ryan Wiener on 2/2/16.
//  Copyright © 2016 Ryan Wiener. All rights reserved.
//

#import "InstructionsViewController.h"
#import "AppDelegate.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController
{
    UIImageView *background;
    UIView *greenBlock;
    UIView *redBlock;
    UIView *blueBlock;
    UILabel *greenLabel;
    UILabel *redLabel;
    UILabel *blueLabel;
    UIButton *backButton;
}

- (void)viewDidLoad
{
    background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"Tap A Block Background.png"];
    background.alpha = .5;
    greenBlock = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4 - self.view.bounds.size.width / 9, self.view.bounds.size.height / 4, self.view.bounds.size.width / 9, self.view.bounds.size.width / 9)];
    greenBlock.backgroundColor = [UIColor greenColor];
    greenBlock.layer.cornerRadius = 7.5;
    greenBlock.layer.masksToBounds = YES;
    redBlock = [[UIView alloc] initWithFrame:CGRectMake(3 * self.view.bounds.size.width / 4, self.view.bounds.size.height / 2, self.view.bounds.size.width / 9, self.view.bounds.size.width / 9)];
    redBlock.backgroundColor = [UIColor redColor];
    redBlock.layer.cornerRadius = 7.5;
    redBlock.layer.masksToBounds = YES;
    blueBlock = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4 - self.view.bounds.size.width / 9, 3 * self.view.bounds.size.height / 4, self.view.bounds.size.width / 9, self.view.bounds.size.width / 9)];
    blueBlock.backgroundColor = [UIColor blueColor];
    blueBlock.layer.cornerRadius = 7.5;
    blueBlock.layer.masksToBounds = YES;
    greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 3, self.view.bounds.size.height / 4, 3 * self.view.bounds.size.width / 5, self.view.bounds.size.height / 4)];
    greenLabel.textColor = [UIColor whiteColor];
    greenLabel.text = @"Tap all of the green blocks before they reach the other side.";
    greenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    greenLabel.numberOfLines = 0;
    greenLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 14];
    redLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 2, 3 * self.view.bounds.size.width / 5, self.view.bounds.size.height / 4)];
    redLabel.textColor = [UIColor whiteColor];
    redLabel.text = @"Don't tap the red blocks!";
    redLabel.lineBreakMode = NSLineBreakByWordWrapping;
    redLabel.numberOfLines = 0;
    redLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 14];
    blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 3, 3 * self.view.bounds.size.height / 4, 3 * self.view.bounds.size.width / 5, self.view.bounds.size.height / 4)];
    blueLabel.textColor = [UIColor whiteColor];
    blueLabel.text = @"Tap the blue blocks and they become green or red.";
    blueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    blueLabel.numberOfLines = 0;
    blueLabel.font = [UIFont systemFontOfSize:self.view.bounds.size.height / 14];
    [self.view addSubview:background];
    [self.view addSubview:greenBlock];
    [self.view addSubview:greenLabel];
    [self.view addSubview:redBlock];
    [self.view addSubview:redLabel];
    [self.view addSubview:blueBlock];
    [self.view addSubview:blueLabel];
}

@end