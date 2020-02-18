//
//  MAMeetingDetailVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MAEditMeetingNote.h"
#import <GoogleMaps/GoogleMaps.h>

@class Meeting;

@interface MAMeetingDetailVC : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Meeting *meeting;
@property (strong, nonatomic) UILabel *meetingNameLabel;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *contentSubview;

@property (strong, nonatomic) UIToolbar *functionBar;

@property (strong, nonatomic) UIImageView *meetingImageView;
@property (strong, nonatomic) UITextView *notesView;
@property (strong, nonatomic) UITextView *meetingDate;
@property (strong, nonatomic) UITextView *meetingMembersCount;
@property (strong, nonatomic) UIButton *viewMeetingMembersButton;

@property (strong, nonatomic) GMSMarker *meetingMarker;

@end