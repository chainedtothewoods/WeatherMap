//
//  WMSearchBaseVC.m
//  WeatherMap
//
//  Created by Michael Lapuebla on 7/14/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

#import "WMSearchBaseVC.h"
@import GoogleMaps;

@interface WMSearchBaseVC () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) GMSPlacesClient *gmPlacesClient;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation WMSearchBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchResultsController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupSearchResultsController {
    _searchBar.delegate = self;
    [_tableView setHidden:true];
    
    _gmPlacesClient = [GMSPlacesClient sharedClient];
    _searchResults = [[NSMutableArray alloc] init];
}

// *******************************************************
#pragma mark - UISearchBarDelegate
// *******************************************************

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if([_searchMapDelegate respondsToSelector:@selector(newSearchStarted)]) {
        [_searchMapDelegate newSearchStarted];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // TODO: Coalesce Search
    
    [self getResultsWithSearchText:searchText];
}

- (void)getResultsWithSearchText:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        [self resetSearch];
    } else {
        NSMutableArray *predictionResults = [[NSMutableArray alloc] init];
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
        
        [_gmPlacesClient autocompleteQuery:searchText bounds:nil filter:filter callback:^(NSArray *results, NSError *error) {
            if (error != nil) {
                NSLog(@"Autocomplete error %@", [error localizedDescription]);
                return;
            }
            
            for (GMSAutocompletePrediction* result in results) {
                [predictionResults addObject:result];
            }
            
            _searchResults = [NSArray arrayWithArray:predictionResults];
            [_tableView reloadData];
        }];
    }
    
    NSLog(@"Results: %@", [_searchResults description]);
}

- (void)resetSearch {
    _searchResults = [[NSArray alloc] init];
    [_tableView reloadData];
}

- (void)searchCompleted {
    [_searchBar setText:@""];
    [_searchBar resignFirstResponder];
    [_tableView setHidden:true];
}
// *******************************************************
#pragma mark - UITableViewDataSource
// *******************************************************

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = [_searchResults count];
    BOOL isHidden = (rowCount == 0);
    
    [_tableView setHidden:isHidden];
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger row = [indexPath row];
    cell.textLabel.attributedText = [(GMSAutocompletePrediction *)_searchResults[row] attributedFullText];
    
    return cell;
}

// *******************************************************
#pragma mark - UITableViewDelegate
// *******************************************************

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *placeID = ((GMSAutocompletePrediction *)_searchResults[indexPath.row]).placeID;
    
    [_gmPlacesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            CLLocationCoordinate2D coordinate = [place coordinate];
            NSLog(@"Longitude: %f -- Latitude: %f", coordinate.longitude, coordinate.latitude);
            
            if([_searchMapDelegate respondsToSelector:@selector(zoomMapToCoordinate:withName:)]) {
                [_searchMapDelegate zoomMapToCoordinate:coordinate withName:place.name];
                [self searchCompleted];
            }
            
        }
    }];
}

@end
