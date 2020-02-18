//
//  MAMeetingListVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAMeetingListVC.h"
#import "MAMeetingDetailVC.h"

#import "MAMeetingCell.h"

#import "Meeting.h"
#import "Meetings.h"

@implementation MAMeetingListVC

- (id)init
{
    self = [super init];
    if(self) {
        self.title = @"Meetings";
        self.tabBarItem.image = [UIImage imageNamed:@"879-mountains"];  ///!!!!!CHANGE THIS IMAGE!!!!//////
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.9 alpha:1.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[Meetings getMeetingsFromArchive] allMeetings];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMeetingAdded)
                                                 name:@"newMeetingAdded"
                                               object:nil];
}

/* ******************************* UITableViewDataSource methods ******************************* */

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[MAMeetingCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    Meeting *meeting = self.dataSource[indexPath.row];
    
    cell.cellName.text = meeting.name;
    //cell.cellImage.image = [photo loadImage:photo.filename];
    
    return cell;
}

/* ******************************* UITableViewDelegate methods ******************************* */

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MAMeetingDetailVC *meetingDetailVC = [[MAMeetingDetailVC alloc] init];
    meetingDetailVC.meeting = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:meetingDetailVC animated:YES];
}

- (void)newMeetingAdded
{
    self.dataSource = [[Meetings getMeetingsFromArchive] allMeetings];
    [self.tableView reloadData];
}
@end
