//
//  Meeting.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.meetingId forKey:@"photoId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.meetingMembers forKey:@"invitees"];
    [aCoder encodeObject:self.meetingPoint forKey:@"location"];
    [aCoder encodeObject:self.venueName forKey:@"venueName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.meetingId = [aDecoder decodeIntegerForKey:@"photoId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.meetingMembers = [aDecoder decodeObjectForKey:@"invitees"];
        self.meetingPoint = [aDecoder decodeObjectForKey:@"location"];
        self.venueName = [aDecoder decodeObjectForKey:@"venueName"];
    }
    return self;
}

//- (UIImage *)loadImage:(NSString *)filename
//{
//    return [UIImage imageNamed:filename];
//}

@end
