//
//  WMSystemMessageView.m
//  WeatherMap
//
//  Created by Mike Limestro on 7/25/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

#import "WMSystemMessageView.h"

@implementation WMSystemMessageView

- (instancetype)init {
    
    if (self = [super init]) {
        self = [self loadViewFromNIB];
        [self setBackgroundColor:[UIColor weatherMapMessageBGBlue]];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
    }
    
    return self;
}

- (WMSystemMessageView *)loadViewFromNIB {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

@end
