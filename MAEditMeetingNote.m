//
//  MAEditMeetingNote.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAEditMeetingNote.h"

#import "Meeting.h"
#import "Meetings.h"

@implementation MAEditMeetingNote

- (id)init
{
    self = [super init];
    if(self) {
        self.title = @"";
    }
    return self;
}

- (void)loadView
{
    self.notesTextView = [[UITextView alloc] init];
    
    UIFontDescriptor *helvetica22 = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue" size:22.0f];
    self.notesTextView.font = [UIFont fontWithDescriptor:helvetica22 size:22.0f];
    self.notesTextView.delegate = self;
    
    self.view = self.notesTextView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.notesTextView.text = self.meeting.notes;
    
    [self.notesTextView becomeFirstResponder];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.notesTextView.frame = CGRectMake(0, 0, 320, 568 - 64 - 216);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *allMeetings = [[Meetings getMeetingsFromArchive] allMeetings];
    NSMutableArray *allMetingsMutable = [[NSMutableArray alloc] initWithArray:allMeetings];
    [allMeetings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj meetingId] == self.meeting.meetingId) {
            self.meeting.notes = self.notesTextView.text;
            [allMetingsMutable replaceObjectAtIndex:idx withObject:self.meeting];
        }
    }];
    Meetings *meetings = [[Meetings alloc] init];
    meetings.allMeetings = [allMetingsMutable copy];
    [Meetings saveMeetingsToArchive:meetings];
}

@end