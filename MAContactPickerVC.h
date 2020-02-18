//
//  MAContactPickerVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/17/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Meeting.h"
#import "Meetings.h"

@interface MAContactPickerVC : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) Meeting *meeting;

- (void)reload;

@end
