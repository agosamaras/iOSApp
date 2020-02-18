//
//  MAEditMeetingNote.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meeting;

@interface MAEditMeetingNote : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Meeting *meeting;
@property (strong, nonatomic) UITextView *notesTextView;

@end
