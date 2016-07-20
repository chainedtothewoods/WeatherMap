//
//  WMSearchBaseVC.h
//  WeatherMap
//
//  Created by Michael Lapuebla on 7/14/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import "WMMainMapVC.h"

@protocol WMSearchBaseVCDelegate <NSObject>
@required
- (void)zoomMapToCoordinate:(CLLocationCoordinate2D)coordinate withName:(NSString *)placeName;
- (void)newSearchStarted;

@end

@interface WMSearchBaseVC : UIViewController

@property (nonatomic, weak) id<WMSearchBaseVCDelegate> searchMapDelegate;

@end
