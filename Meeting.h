//
//  Meeting.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Meeting : NSObject <NSCoding>

@property (assign, nonatomic) NSInteger meetingId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *meetingMembers;
@property (strong, nonatomic) CLLocation *meetingPoint;
@property (strong, nonatomic) NSString *venueName;
//- (UIImage *)loadImage:(NSString *)filename;

@end