//
//  MAContactDetailVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/17/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAContactDetailVC.h"

@interface MAContactDetailVC ()

-(void)populateContactData;

@end

@implementation MAContactDetailVC

- (id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Member's Details";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tblContactDetails setDelegate:self];
    [_tblContactDetails setDataSource:self];
    
    [self populateContactData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateContactData{
    NSString *contactFullName = [NSString stringWithFormat:@"%@ %@", [_dictContactDetails objectForKey:@"firstName"], [_dictContactDetails objectForKey:@"lastName"]];
    
    [_lblContactName setText:contactFullName];
    
    // Set the contact image.
    if ([_dictContactDetails objectForKey:@"image"] != nil)
    {
        [_imgContactImage setImage:[UIImage imageWithData:[_dictContactDetails objectForKey:@"image"]]];
    }
    
    [_tblContactDetails reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section)
    {
        case 0:
            return @"Phone Numbers";
            break;
        case 1:
            return @"E-mail Addresses";
            break;
        case 2:
            return @"Address Info";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];///εδω μαλλον θα εχω προβλημα
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    NSString *detailText = @"";
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"mobileNumber"];
                    detailText = @"Mobile Number";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"homeNumber"];
                    detailText = @"Home Number";
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row)
        {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"homeEmail"];
                    detailText = @"Home E-mail";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"workEmail"];
                    detailText = @"Work E-mail";
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row)
        {
                case 0:
                    cellText = [_dictContactDetails objectForKey:@"address"];
                    detailText = @"Street Address";
                    break;
                case 1:
                    cellText = [_dictContactDetails objectForKey:@"zipCode"];
                    detailText = @"ZIP Code";
                    break;
                case 2:
                    cellText = [_dictContactDetails objectForKey:@"city"];
                    detailText = @"City";
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
