//
//  WMNavigationBar.m
//  WeatherMap
//
//  Created by Michael Lapuebla on 7/23/16.
//  Copyright © 2016 Michael Lapuebla. All rights reserved.
//

#import "WMNavigationBar.h"

#define kWMNavigationBarShadowColor         [UIColor blackColor].CGColor
#define kWMNavigationBarShadowOffset        CGSizeMake(0, 4)
#define kWMNavigationBarShadowOpacity       0.25

@implementation WMNavigationBar

CAGradientLayer *gradientLayer;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Setup Gradient
    if(gradientLayer != nil) {
        [gradientLayer removeFromSuperlayer];
    }
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = CGRectMake(0.0, 0.0 - statusBarSize.height, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarSize.height);
    [gradientLayer setColors:@[(id)[UIColor weatherMapBlue].CGColor, (id)[UIColor weatherMapDarkYellow].CGColor, (id)[UIColor weatherMapYellow].CGColor]];
    [self.layer insertSublayer:gradientLayer atIndex:1];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    // Add Dropshadow to Navigation Bar
    [self.layer setShadowColor:kWMNavigationBarShadowColor];
    [self.layer setShadowOpacity:kWMNavigationBarShadowOpacity];
    [self.layer setShadowOffset:kWMNavigationBarShadowOffset];
    [self.layer setShouldRasterize:YES];

}

@end
