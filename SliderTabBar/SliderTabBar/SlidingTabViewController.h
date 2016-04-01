//
//  SlidingTabViewController.h
//  SliderTabBar
//
//  Created by Monu Rathor on 11/03/16.
//  Copyright © 2016 MR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingTabViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *controllers;

- (void)addControllersWithStoryBoard:(UIStoryboard *)storyboard Itdentifiers:(NSArray *)identifires OnView:(UIView *)view;

@end
