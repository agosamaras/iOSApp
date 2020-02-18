//
//  MACreateMeetingVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meeting;

@interface MACreateMeetingVC : UIViewController

@property (strong, nonatomic) UIScrollView *contentSubview;
@property (strong, nonatomic) Meeting *aMeeting;


@property (strong, nonatomic) UILabel *meetingNameLabel;
@property (strong, nonatomic) UITextField *nameText;

@property (strong, nonatomic) UILabel *meetingNotesLabel;
@property (strong, nonatomic) UITextField *notesText;

@property (strong, nonatomic) UILabel *meetingPlaceLabel;
@property (strong, nonatomic) UITextField *meetingPlaceText;
@property (strong, nonatomic) UIButton *pickLocationButton;

@property (strong, nonatomic) UILabel *meetingMembersLabel;
@property (strong, nonatomic) UIButton *pickMembersButton;

@property (strong, nonatomic) UILabel *meetingDateLabel;
@property(strong, nonatomic) NSDate *meetingDate;
@property (strong, nonatomic) UIButton *pickDateButton;

@property (strong, nonatomic) UIButton *createMeetingButton;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end
