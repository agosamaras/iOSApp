//
//  MAMeetingMembersListCell.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/21/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAMeetingMembersListCell.h"

@implementation MAMeetingMembersListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellName = [[UILabel alloc] init];
        
        self.cellName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
        self.cellName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cellName];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellName.frame = CGRectMake(5,
                                     17,
                                     160,
                                     16);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end