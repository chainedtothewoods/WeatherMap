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
@import Aeris;
@import AerisUI;

#define kObservationViewHeight  200.0

@interface WMMainMapVC () <WMSearchBaseVCDelegate>

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) WMSearchBaseVC *searchPlacesVC;
@property (nonatomic, strong) AWFObservationsLoader *obsLoader;
@property (nonatomic, strong) AWFObservationView *obsView;

@end

@implementation WMMainMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWeatherObservationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupWeatherObservationView {
    _obsLoader = [[AWFObservationsLoader alloc] init];
    
    CGRect viewFrame = self.view.frame;
    _obsView = [[AWFObservationView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viewFrame) - kObservationViewHeight, CGRectGetWidth(viewFrame), kObservationViewHeight)];
    [_obsView setHidden:true];
    [self.view addSubview:_obsView];
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

- (void)zoomMapToCoordinate:(CLLocationCoordinate2D)coordinate withName:(NSString *)placeName {
    NSLog(@"Completed!");
    [_mapView setCenterCoordinate:coordinate zoomLevel:5 animated:true];
    
    [self weatherInfoForCoodinate:coordinate withName:placeName];
}

- (void)newSearchStarted {
    [_obsView setHidden:true];
}

- (void)weatherInfoForCoodinate:(CLLocationCoordinate2D)coordinate withName:(NSString *)placeName {
    AWFPlace *tempPlace = [AWFPlace placeWithCoordinate:coordinate];
    __weak typeof(self.obsView) weakObsView = _obsView;
    [_obsLoader getObservationForPlace:tempPlace options:nil completion:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Observation data failed to load! %@", error);
            return;
        }
        
        if ([objects count] > 0) {
            [weakObsView setHidden:false];
            AWFObservation *obs = (AWFObservation *)[objects objectAtIndex:0];
            
            // determine winds string
            NSInteger windSpeed = [obs.windSpeedMPH intValue];
            NSString *windStr = [NSString stringWithFormat:@"%@ %i mph", obs.windDirection, [obs.windSpeedMPH intValue]];
            if (windSpeed == 0) {
                windStr = @"Calm";
            }
            
            weakObsView.locationTextLabel.text = placeName;
            weakObsView.tempTextLabel.text = [NSString stringWithFormat:@"%li%@", (long)[obs.tempF integerValue], AWFDegree];
            weakObsView.weatherTextLabel.text = obs.weather;
            NSString *iconPath = [NSString stringWithFormat:@"%@/wxicons/%@", @"AerisUI.bundle", obs.icon];
            weakObsView.iconImageView.image = [AWFImage weatherIconNamed:iconPath];
            weakObsView.feelslikeTextLabel.text = [NSString stringWithFormat:@"Feels Like %li%@", (long)[obs.feelslikeF integerValue], AWFDegree];
            weakObsView.windsTextLabel.text = windStr;
            weakObsView.dewpointTextLabel.text = [NSString stringWithFormat:@"%i%@", [obs.dewpointF intValue], AWFDegree];
            weakObsView.humidityTextLabel.text = [NSString stringWithFormat:@"%i%%", [obs.humidity intValue]];
            weakObsView.pressureTextLabel.text = [NSString stringWithFormat:@"%.2f in", [obs.pressureIN floatValue]];
            
        }
    }];
}

@end
