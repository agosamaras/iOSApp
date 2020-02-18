//
//  MAMeetingMembersListCell.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/21/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAFoursquareCell.h"

@implementation MAFoursquareCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellName = [[UILabel alloc] init];
        
        self.cellName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        self.cellName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellName];
        
        self.cellAddress = [[UILabel alloc] init];
        
        self.cellAddress.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f];
        self.cellAddress.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellAddress];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellName.frame = CGRectMake(5,
                                     5,
                                     500,
                                     19);
    
    self.cellAddress.frame = CGRectMake(5,
                                        25,
                                        500,
                                        16);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end