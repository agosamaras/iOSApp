//
//  MAMeetingMapVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 12/30/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAMeetingMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MADirections.h"

@interface MAMeetingMapVC ()<GMSMapViewDelegate>

//@property(strong, nonatomic) GMSMapView *meetingMapView;

@end

@implementation MAMeetingMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"Directions" forState:UIControlStateNormal];
    editButton.frame = CGRectMake(editButton.frame.origin.x, editButton.frame.origin.y, 90.0, 30.0);
    [editButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *cEditButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = cEditButtonItem;

    self.meetingMapView.delegate = self;

    self.meetingMapView.myLocationEnabled = YES;
    self.meetingMapView.settings.compassButton = YES;
    self.meetingMapView.myLocationEnabled = YES;
    self.meetingMapView.settings.myLocationButton = YES;
    self.meetingMapView.settings.zoomGestures = YES;
    
    [self.meetingMapView setMinZoom:5 maxZoom:18];
    
    self.view = self.meetingMapView;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _meetingMapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 100,
                                        0,
                                        self.bottomLayoutGuide.length +100,
                                        0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    UIView *infoWindow = [[UIView alloc ] init];
    infoWindow.frame = CGRectMake(0, 0, 260, 86);
    
    infoWindow.backgroundColor = [UIColor redColor];
    
    UILabel *truckNameLabel = [[UILabel alloc] init];
    truckNameLabel.frame = CGRectMake(17 + 15, 17, 165, 28);
    truckNameLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithFontAttributes:@{NSFontAttributeName: @"Arial"}] size:19.0f];
    truckNameLabel.textColor = [UIColor blackColor];
    truckNameLabel.text = self.meetingMarker.title;
    NSLog(@"Now %@", self.meetingMarker.title);
    [infoWindow addSubview:truckNameLabel];
    
    UILabel *truckAddressLabel = [[UILabel alloc] init];
    truckAddressLabel.numberOfLines = 0;
    truckAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    truckAddressLabel.frame = CGRectMake(CGRectGetMinX(truckNameLabel.frame), CGRectGetMaxY(truckNameLabel.frame), 165, 32);
    truckAddressLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithFontAttributes:@{NSFontAttributeName: @"Arial"}] size:13.0f];
    truckAddressLabel.textColor = [UIColor grayColor];
    [infoWindow addSubview:truckAddressLabel];
    
    return infoWindow;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{    
    if(mapView.myLocation != nil) {
        NSURL *directionsURL = [NSURL URLWithString:
                                [NSString stringWithFormat:
                                 @"%@?origin=%f,%f&destination=%f,%f&sensor=false",
                                 @"http://maps.googleapis.com/maps/api/directions/json",
                                 mapView.myLocation.coordinate.latitude,
                                 mapView.myLocation.coordinate.longitude,
                                 marker.position.latitude,
                                 marker.position.longitude
                                 ]];
        
        NSURLSessionDataTask *directionsTask = [self.directionsSession dataTaskWithURL:directionsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
            
            NSError *error = nil;
            NSDictionary *json =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingMutableContainers
                                              error:&error];
            
            // TODO: If the error object is nil, set the self.steps array equal to the steps returned in the JSON response dictionary, which can be accessed here: [@"routes"][0][@"legs"][0][@"steps"]
            if (!error) {
                self.steps = json[@"routes"][0][@"legs"][0][@"steps"];
            }
            
        }];
        
        [directionsTask resume];
    }
}

- (void)editButtonTapped:(id)sender
{
    MADirections *directionsVC = [[MADirections alloc] init];
    directionsVC.steps = self.steps;
        [self presentViewController:directionsVC
                       animated:YES
                     completion:nil];
}
@end
