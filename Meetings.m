//
//  Meetings.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "Meetings.h"

@implementation Meetings

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.allMeetings forKey:@"allMeetings"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.allMeetings = [aDecoder decodeObjectForKey:@"allMeetings"];
    }
    return self;
}

+ (NSString *)pathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"meetings.model"];
}

+ (Meetings *)getMeetingsFromArchive {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Meetings pathToArchive]];
}

+ (void)saveMeetingsToArchive:(NSArray *)meetings {
    [NSKeyedArchiver archiveRootObject:meetings toFile:[Meetings pathToArchive]];
}

@end
