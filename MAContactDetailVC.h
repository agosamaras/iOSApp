//
//  MAContactDetailVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/17/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAContactDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;

@end
