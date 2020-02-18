//
//  FSVenueSearchVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 2/20/15.
//  Copyright (c) 2015 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BZFoursquare.h"
#import "Meeting.h"

@interface FSVenueSearchVC : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate> {
    NSMutableArray *searchData;
}

@property (strong, nonatomic,readonly) BZFoursquare *foursquare;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) Meeting *meeting;
@property (strong, nonatomic) UIToolbar *functionBar;
@property (strong, nonatomic) UIButton *customButton;
@property (strong, nonatomic) UITextField *searchField;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;


@end
