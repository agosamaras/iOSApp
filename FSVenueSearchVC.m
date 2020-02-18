//
//  FSVenueSearchVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 2/20/15.
//  Copyright (c) 2015 Λεανδρος Τζανακης. All rights reserved.
//

#import "FSVenueSearchVC.h"
#import "BZFoursquare.h"
#import "BZFoursquareRequest.h"
#import "MAMeetingMembersListCell.h"
#import "MAFoursquareCell.h"

#define kClientID       @"PH3EUE13ZGWZY3RGGTFGNBNXEMA42RFBTL1Q0PHHGXNAMAWW"
#define kCallbackURL    @"fsqdemo://foursquare"

@interface FSVenueSearchVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>
@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *response;
- (void)updateView;
- (void)cancelRequest;
- (void)prepareForRequest;
- (void)searchVenues:(NSString *)query;
@property(nonatomic,strong) NSArray *germanMakes2;
@end

@implementation FSVenueSearchVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        _foursquare.version = @"20120609";
        _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        _foursquare.sessionDelegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _foursquare.sessionDelegate = nil;
    [self cancelRequest];
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.9 alpha:1.0];
    self.tableView.delegate = self;
    
    self.view = self.tableView;
    
    self.functionBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   60,
                                                                   44)];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     250,
                                                                     30)];
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchField.placeholder = @"Search Foursquare";
    self.searchField.delegate = self;
    UIBarButtonItem *textFieldItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchField];
    
    self.customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.customButton setTitle:@"Search" forState:UIControlStateNormal];
    self.customButton.tintColor = [UIColor redColor];
    [self.customButton addTarget:self
                          action:@selector(searchButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
    self.customButton.showsTouchWhenHighlighted = YES;
    self.customButton.frame = CGRectMake(0,
                                         0,
                                         50,
                                         30);
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:self.customButton];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.functionBar setItems:@[flexibleSpace, textFieldItem, flexibleSpace, searchButton, flexibleSpace]];
    self.tableView.tableHeaderView = self.functionBar;
    
//    ///////////////Location Manager////////////////////////////////////////////////////////////////
//    [self.locationManager requestWhenInUseAuthorization];
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
//        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
//    [self.locationManager startUpdatingLocation];
//    }
//    
    ///////////////////////////////////////////2/////////////////////////////////////////////////
//    self.locationManager = [[CLLocationManager alloc]init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.delegate = self;
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
//            // We never ask for authorization. Let's request it.
//            [self.locationManager requestWhenInUseAuthorization];
//        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
//                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
//            // We have authorization. Let's update location.
//            [self.locationManager startUpdatingLocation];
//        } else {
//            // If we are here we have no pormissions.
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No athorization"
//                                                                message:@"Please, enable access to your location"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"Cancel"
//                                                      otherButtonTitles:@"Open Settings", nil];
//            [alertView show];
//        }
//    } else {
//        // This is iOS 7 case.
//        [self.locationManager startUpdatingLocation];
//    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    [self cancelRequest];
    [self searchVenues:self.query];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FS methods

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.response = request.response;
    self.request = nil;
    
    [self updateView];
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.response = request.response;
    self.request = nil;
    [self updateView];
}

- (void)updateView {
    if ([self isViewLoaded]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView reloadData];
        if (indexPath) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)cancelRequest {
    if (_request) {
        _request.delegate = nil;
        [_request cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.response = nil;
}

- (void)searchVenues:(NSString *)query {
    
    
    if (self) {
        self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        _foursquare.version = @"20120609";
        _foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        _foursquare.sessionDelegate = self;
    }
    
    
    
    [self prepareForRequest];
    //self.location.coordinate.latitude
//    NSDictionary *parameters = @{@"ll": @"40.7,-74", @"query": query, @"limit": @"10", @"intent": @"checkin"};//////PARAMETERS//
//    NSDictionary *parameters = @{@"ll": @"39.6,22.4", @"query": query, @"limit": @"10", @"intent": @"global"};//////PARAMETERS//
    NSDictionary *parameters = @{@"query": query, @"limit": @"10", @"intent": @"global"};//////PARAMETERS//

    
//    NSString *tempLL = [NSString stringWithFormat:@"%.02f,%.02f",self.location.coordinate.latitude,self.location.coordinate.longitude];
//    NSDictionary *parameters = @{@"ll": tempLL, @"query": query, @"limit": @"10", @"intent": @"checkin"};//////PARAMETERS//
    
    self.request =[_foursquare userlessRequestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [_request start];

    
    NSLog(@"Request made with query: %@",query);
}

# pragma mark - Location manager methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self cancelRequest];
    [self searchVenues:self.query];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location manager did fail with error %@", error);
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[_response valueForKeyPath:@"venues.name"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAFoursquareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[MAFoursquareCell alloc] initWithStyle:0 reuseIdentifier:@"cell" ];
    }
    
    cell.cellName.text  = [[_response valueForKeyPath:@"venues.name"] objectAtIndex:[indexPath row]];
    if ([[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"crossStreet"]) {
        NSString *tempAddress = [[NSString alloc] initWithFormat:@"%@ & %@",[[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"address"], [[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"crossStreet"]];
        cell.cellAddress.text = tempAddress;
        [tempAddress release];
    }else{
    cell.cellAddress.text = [[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"address"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSNumber *lat = [[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"lat"];
    NSNumber *lng = [[_response valueForKeyPath:@"venues.location"][indexPath.row] objectForKey:@"lng"];
    self.meeting.meetingPoint = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
    
    self.meeting.venueName = [[_response valueForKeyPath:@"venues.name"] objectAtIndex:[indexPath row]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonTapped
{
    NSLog(@"search button tapped with search data: %@", self.searchField.text);
    [self searchVenues:self.searchField.text];
}

@end
