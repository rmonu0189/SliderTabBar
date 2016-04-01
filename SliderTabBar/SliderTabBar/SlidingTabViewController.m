//
//  SlidingTabViewController.m
//  SliderTabBar
//
//  Created by Monu Rathor on 11/03/16.
//  Copyright © 2016 MR. All rights reserved.
//

#import "SlidingTabViewController.h"


//-- Settings of slider tab
#pragma mark - Sliding tab settings
#pragma mark -

#define SLIDER_BUTTON_HEIGHT    50.0f

#define SLIDER_SELECTED_BUTTON_COLOR [UIColor colorWithRed:233.0/255.0 green:33.0/255.0 blue:45.0/255.0 alpha:1.0]
#define SLIDER_DESELECTED_BUTTON_COLOR [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0]
#define SLIDER_BUTTON_FONT [UIFont systemFontOfSize:15.0]

#pragma mark -

@interface SlidingTabViewController () <UICollectionViewDataSource, UICollectionViewDelegate>{
    CALayer *bottomBorder;
    NSInteger selectedIndex;
    BOOL isClickedButton;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *buttonScroll;
@end

@implementation SlidingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controllers = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addControllersWithStoryBoard:(UIStoryboard *)storyboard Itdentifiers:(NSArray *)identifires OnView:(UIView *)view{
    for (NSString *storyboardName in identifires) {
        [self.controllers addObject:[storyboard instantiateViewControllerWithIdentifier:storyboardName]];
    }
    [self performSelector:@selector(setUpCollectionView:) withObject:view afterDelay:0.0];
}

- (void)setUpCollectionView:(UIView *)view{
    
    //-- Create button scrollview
    _buttonScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, SLIDER_BUTTON_HEIGHT)];
    _buttonScroll.showsHorizontalScrollIndicator = NO;
    _buttonScroll.showsVerticalScrollIndicator = NO;
    
    //-- Create Flow Layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //-- Create Collection View
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SLIDER_BUTTON_HEIGHT, view.frame.size.width, view.frame.size.height-SLIDER_BUTTON_HEIGHT) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"controllers"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //-- Add Collection View
    [view addSubview:_buttonScroll];
    [view addSubview:_collectionView];
    
    [self addSliderButton];
    
    //-- Update controllers
    [_collectionView reloadData];
}

- (void)addSliderButton{
    CGFloat x = 8;
    for (int i=0; i<self.controllers.count; i++) {
        UIViewController *controller = [self.controllers objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SLIDER_BUTTON_FONT;
        CGRect rect = [self getStringSize:controller.title Font:SLIDER_BUTTON_FONT];
        rect.origin.x = x;
        rect.origin.y = 0;
        rect.size.height = SLIDER_BUTTON_HEIGHT;
        rect.size.width = rect.size.width+20;
        button.frame = rect;
        button.tag = i;
        [button setTitle:controller.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScroll addSubview:button];
        x = x+rect.size.width+8;
    }
    
    if (x < _buttonScroll.frame.size.width) {
        //-- Rearrance button frame
        
        CGFloat width = _buttonScroll.frame.size.width/self.controllers.count;
        x=0;
        for (id subview in _buttonScroll.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                CGRect rect = CGRectMake(x, 0, width, SLIDER_BUTTON_HEIGHT);
                ((UIButton *)subview).frame = rect;
                x = x+width+8;
            }
        }
    }
    [_buttonScroll setContentSize:CGSizeMake(x, SLIDER_BUTTON_HEIGHT)];
    selectedIndex = 9999;
    [self selectedButtonAtIndex:0];
}

- (void)disableClickedButton{
    isClickedButton = NO;
}

- (void)selectedButtonAtIndex:(NSInteger)index{
    if (selectedIndex != index) {
        selectedIndex = index;
        UIButton *selectedButton = nil;
        for (id subview in _buttonScroll.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                if (!bottomBorder) {
                    bottomBorder = [CALayer layer];
                }
                [bottomBorder removeFromSuperlayer];
                if (index == ((UIButton *)subview).tag) {
                    selectedButton = (UIButton *)subview;
                }
                else{
                    [((UIButton *)subview) setTitleColor:SLIDER_DESELECTED_BUTTON_COLOR forState:UIControlStateNormal];
                }
            }
        }
        
        if (selectedButton) {
            bottomBorder.frame = CGRectMake(0.0f, SLIDER_BUTTON_HEIGHT-2, selectedButton.frame.size.width, 2.0f);
            bottomBorder.backgroundColor = SLIDER_SELECTED_BUTTON_COLOR.CGColor;
            [selectedButton.layer addSublayer:bottomBorder];
            [selectedButton setTitleColor:SLIDER_SELECTED_BUTTON_COLOR forState:UIControlStateNormal];
        }
        
        //-- Show Scroll position
        //-- Set Offset
        CGRect screen = [UIScreen mainScreen].bounds;
        CGFloat difference = selectedButton.center.x-screen.size.width/2;
        CGFloat maxX = _buttonScroll.contentSize.width - screen.size.width;
        
        if (difference <= 0) {
            [_buttonScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (difference > 0 && difference < maxX){
            [_buttonScroll setContentOffset:CGPointMake(difference, 0) animated:YES];
        }
        else{
            [_buttonScroll setContentOffset:CGPointMake(maxX, 0) animated:YES];
        }
        
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


- (IBAction)clickedScrollButton:(id)sender{
    isClickedButton = YES;
    [self performSelector:@selector(disableClickedButton) withObject:nil afterDelay:0.3];
    [self selectedButtonAtIndex:((UIButton *)sender).tag];
}

- (CGRect)getStringSize:(NSString *)string Font:(UIFont *)font{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, SLIDER_BUTTON_HEIGHT)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil];
}

#pragma mark collection view delegate and data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"controllers" forIndexPath:indexPath];
    if ([[self.controllers objectAtIndex:indexPath.row] isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = [self.controllers objectAtIndex:indexPath.row];
        controller.view.frame = CGRectMake(0, 0, _collectionView.frame.size.width, _collectionView.frame.size.height);
        [cell.contentView addSubview:controller.view];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *index = [collectionView indexPathForCell:cell];
        if (isClickedButton == NO) {
            [self selectedButtonAtIndex:index.row];
        }
    }
}

@end
