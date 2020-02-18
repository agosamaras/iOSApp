//
//  MACreateMeetingVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MACreateMeetingVC.h"
#import "MADatePickerVC.h"
#import "MAContactPickerVC.h"

#import "FSVenueSearchVC.h"

#import "BZFoursquare.h"

#import "Meeting.h"
#import "Meetings.h"

#define myCallbackURL           @"fsqdemo://foursquare"

@interface MACreateMeetingVC ()

@end

@implementation MACreateMeetingVC

- (id)init
{
    self = [super init];
    if(self) {
        self.title = @"Create a new Meeting";
        self.tabBarItem.image = [UIImage imageNamed:@"714-camera"];
    }
    return self;
}

- (void)loadView
{
    Meeting *newMeeting = [[Meeting alloc] init];
    self.aMeeting = newMeeting;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.9 alpha:1.0];
    
    self.contentSubview = [[UIScrollView alloc] init];
    
    self.meetingNameLabel = [[UILabel alloc] init];
    [self.contentSubview addSubview:self.meetingNameLabel];
    self.nameText = [[UITextField alloc] init];
    self.nameText.borderStyle = UITextBorderStyleRoundedRect;
    self.nameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameText.placeholder = @"Type a name...";
    [self.contentSubview addSubview:self.nameText];
    
    self.meetingNotesLabel = [[UILabel alloc] init];
    [self.contentSubview addSubview:self.meetingNotesLabel];
    self.notesText = [[UITextField alloc] init];
    self.notesText.borderStyle = UITextBorderStyleRoundedRect;
    self.notesText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.notesText.placeholder = @"Type a name...";
    [self.contentSubview addSubview:self.notesText];
    
    self.meetingPlaceLabel = [[UILabel alloc] init];
    [self.contentSubview addSubview:self.meetingPlaceLabel];
    self.meetingPlaceText = [[UITextField alloc] init];
    self.meetingPlaceText.borderStyle = UITextBorderStyleRoundedRect;
    self.meetingPlaceText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.meetingPlaceText.placeholder = @"Type a name...";
    [self.contentSubview addSubview:self.meetingPlaceText];
    
    self.meetingMembersLabel = [[UILabel alloc] init];
    [self.contentSubview addSubview:self.meetingMembersLabel];
    
    self.pickMembersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickMembersButton setTitle:@"Add invitees" forState:UIControlStateNormal];
    self.pickMembersButton.tintColor = [UIColor orangeColor];
    [self.contentSubview addSubview:self.pickMembersButton];
    
    self.meetingDateLabel = [[UILabel alloc] init];
    [self.contentSubview addSubview:self.meetingDateLabel];
    //[self.contentSubview addSubview:self.meetingDate];
    
    self.meetingNameLabel.backgroundColor = [UIColor clearColor];
    self.meetingNameLabel.textColor = [UIColor whiteColor];
    self.meetingNotesLabel.backgroundColor = [UIColor clearColor];
    self.meetingNotesLabel.textColor = [UIColor whiteColor];
    self.meetingDateLabel.backgroundColor = [UIColor clearColor];
    self.meetingDateLabel.textColor = [UIColor whiteColor];
    self.meetingMembersLabel.backgroundColor = [UIColor clearColor];
    self.meetingMembersLabel.textColor = [UIColor whiteColor];
    self.meetingPlaceLabel.backgroundColor = [UIColor clearColor];
    self.meetingPlaceLabel.textColor = [UIColor whiteColor];
    
    self.pickDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickDateButton setTitle:@"Select a date" forState:UIControlStateNormal];
    self.pickDateButton.tintColor = [UIColor purpleColor];
    [self.contentSubview addSubview:self.pickDateButton];
    
    self.pickLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickLocationButton setTitle:@"Select a place" forState:UIControlStateNormal];
    self.pickLocationButton.tintColor = [UIColor brownColor];
    [self.contentSubview addSubview:self.pickLocationButton];
    
    self.createMeetingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.createMeetingButton setTitle:@"Save" forState:UIControlStateNormal];
    self.createMeetingButton.tintColor = [UIColor redColor];
    [self.contentSubview addSubview:self.createMeetingButton];
    
    [view addSubview:self.contentSubview];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.meetingNameLabel.text = @"Name your meeting!!!!!!!!!!";
    self.meetingNotesLabel.text = @"Add some useful info about the meeting";
    self.meetingDateLabel.text = @"Select a date for your meeting";
    self.meetingMembersLabel.text = @"Add invitees";
    self.meetingPlaceLabel.text = @"Pick a spot";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.notesTextView.text = self.meeting.notes;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.contentSubview.frame = CGRectMake(0,
                                           0,
                                           CGRectGetWidth(self.view.frame),
                                           CGRectGetHeight(self.view.frame));
    
    self.meetingNameLabel.frame = CGRectMake(50,
                                             30,
                                             200,
                                             44);//self.meetingNameLabel.font.pointSize + 5);
    self.nameText.frame = CGRectMake(50, 80, 280, 30);
    
    self.meetingNotesLabel.frame = CGRectMake(50, 120, 350, 44);
    self.notesText.frame = CGRectMake(50, 150, 280, 30);
    self.meetingDateLabel.frame = CGRectMake(50, 200, 250, 30);
    self.pickDateButton.frame = CGRectMake(50, 210, 150, 50);
    self.meetingMembersLabel.frame = CGRectMake(50, 250, 250, 30);
    self.pickMembersButton.frame = CGRectMake(50, 280, 150, 50);
    self.meetingPlaceLabel.frame = CGRectMake(50, 340, 250, 30);
    self.meetingPlaceText.frame = CGRectMake(50, 370, 250, 30);
    self.pickLocationButton.frame = CGRectMake(50, 400, 150, 50);
    
    self.createMeetingButton.frame = CGRectMake(50, 450, 80, 50);
    self.contentSubview.contentSize = CGSizeMake(CGRectGetWidth(self.contentSubview.frame), CGRectGetMaxY(self.meetingNameLabel.frame));
    
    [self.pickDateButton addTarget:self
                            action:@selector(pickDate)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.pickMembersButton addTarget:self
                               action:@selector(pickMembers)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.pickLocationButton addTarget:self
                                action:@selector(pickLocation)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.createMeetingButton addTarget:self
                                 action:@selector(saveMeeting)
                       forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)pickDate
{
    MADatePickerVC *datePickerVC = [[MADatePickerVC alloc] init];
    datePickerVC.meeting = self.aMeeting;
    [self.navigationController pushViewController:datePickerVC animated:YES];
}

- (void)pickMembers
{
    NSLog(@"pickMembers button tapped");
    MAContactPickerVC *contactPickerVC = [[MAContactPickerVC alloc] init];
    contactPickerVC.meeting = self.aMeeting;
    [self.navigationController pushViewController:contactPickerVC animated:YES];
}

- (void)pickLocation
{
    NSLog(@"pickLocation button tapped");
    
    FSVenueSearchVC *placePickerVC = [[FSVenueSearchVC alloc] init];
    placePickerVC.query = self.meetingPlaceText.text;
    NSLog(@"%@",placePickerVC.query);
    placePickerVC.meeting = self.aMeeting;
    [self.navigationController pushViewController:placePickerVC animated:YES];
}

- (void)saveMeeting
{
    self.aMeeting.name = self.nameText.text;
    self.aMeeting.notes = self.notesText.text;
    NSLog(@"saveMeetingButton tapped");
    
    if (self.aMeeting) {
        NSLog(@"Object created with name %@, date %@ and number of invitees %lu",self.aMeeting.name, self.aMeeting.date, (unsigned long)self.aMeeting.meetingMembers.count);
    }
    else
    {
        NSLog(@"You get nothing for nothing, if thats what you do");
    }
    
    NSArray *allMeetings = [[Meetings getMeetingsFromArchive] allMeetings];
    NSMutableArray *allMetingsMutable = [[NSMutableArray alloc] initWithArray:allMeetings];
    [allMetingsMutable insertObject:self.aMeeting atIndex:0];
    Meetings *meetings = [[Meetings alloc] init];
    meetings.allMeetings = [allMetingsMutable copy];
    [Meetings saveMeetingsToArchive:meetings];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newMeetingAdded"
                                                        object:nil];
}

@end
