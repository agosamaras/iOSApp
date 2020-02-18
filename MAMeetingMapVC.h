//
//  MAMeetingMapVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 12/30/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MAMeetingMapVC : UIViewController

@property(strong, nonatomic) GMSMapView *meetingMapView;
@property(strong, nonatomic) GMSMarker *meetingMarker;
@property(strong, nonatomic) NSURLSession *directionsSession;
@property(copy, nonatomic) NSArray *steps;
@property(strong, nonatomic) UIButton *directionsButton;

@end
