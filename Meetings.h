//
//  Meetings.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meeting;

@interface Meetings : NSObject<NSCoding>

@property (strong, nonatomic) NSArray *allMeetings;

+ (Meetings *)getMeetingsFromArchive;
+ (void)saveMeetingsToArchive:(Meetings *)meetings;

@end
