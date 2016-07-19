//
//  WMMainMapVC.m
//  WeatherMap
//
//  Created by Michael Lapuebla on 7/18/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

#import "WMMainMapVC.h"
#import "WMSearchBaseVC.h"
@import Mapbox;

@interface WMMainMapVC () <WMSearchBaseVCDelegate>

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) WMSearchBaseVC *searchPlacesVC;

@end

@implementation WMMainMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// *******************************************************
#pragma mark - Navigation
// *******************************************************

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    
    if([segueName isEqualToString:@"searchGooglePlaces"]) {
        _searchPlacesVC = (WMSearchBaseVC *)[segue destinationViewController];
        _searchPlacesVC.searchMapDelegate = self;
    }
}

// *******************************************************
#pragma mark - WMSearchBaseVCDelegate
// *******************************************************

- (void)zoomMapToCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"Completed!");
    [_mapView setCenterCoordinate:coordinate zoomLevel:5 animated:true];
}
@end
