//
//  ViewController.m
//  SliderTabBar
//
//  Created by Monu Rathor on 11/03/16.
//  Copyright © 2016 MR. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addControllersWithStoryBoard:self.storyboard Itdentifiers:@[@"firstView", @"secondView", @"thirdView"] OnView:self.sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
