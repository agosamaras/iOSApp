//
//  MAContactPickerVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/17/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAContactPickerVC.h"
#import "MAContactDetailVC.h"
#import "MAMeetingMembersListCell.h"

@interface MAContactPickerVC ()

@property (strong, nonatomic) ABPeoplePickerNavigationController *addressBookController;
@property (strong, nonatomic) NSMutableArray *contactsData;

- (void)showAddressBook;

@end

@implementation MAContactPickerVC

- (id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Meeting's Members";
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.9 alpha:1.0];
    self.tableView.delegate = self;
    
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddressBook)];
    
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.meeting.meetingMembers = _contactsData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_contactsData)
    {
        return _contactsData.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAMeetingMembersListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[MAMeetingMembersListCell alloc] initWithStyle:0 reuseIdentifier:@"cell" ];
    }
    
    NSDictionary *contactInfoDict = [_contactsData objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)showAddressBook
{
    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

/////////////////
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSMutableDictionary *contactInfoDictionary = [[NSMutableDictionary alloc]
                                                  initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @"", @""]
                                                  forKeys:@[@"firstName", @"lastName", @"image", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    
    CFTypeRef generalCFObject;
    ABMultiValueRef phonesRef, emailsRef, addressRef;
    
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (generalCFObject)
    {
        [contactInfoDictionary setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject)
    {
        [contactInfoDictionary setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++)
    {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo)
        {
            [contactInfoDictionary setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo)
        {
            [contactInfoDictionary setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    
    emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++)
    {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo)
        {
            [contactInfoDictionary setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo)
        {
            [contactInfoDictionary setObject:(__bridge NSString *)currentEmailValue forKey:@"workEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
    }
    CFRelease(emailsRef);
    
    addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(addressRef) > 0)
    {
        NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
        [contactInfoDictionary setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
        [contactInfoDictionary setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
        [contactInfoDictionary setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
    }
    CFRelease(addressRef);
    
    if (_contactsData == nil)
    {
        _contactsData = [[NSMutableArray alloc] init];
    }
    [_contactsData addObject:contactInfoDictionary];
    
    [self.tableView reloadData];
    
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"new item with first name  :  %@", contactInfoDictionary[@"firstName"]);
}
/////////////////

-       (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MAContactDetailVC *contactDetailVC = [[MAContactDetailVC alloc] init];
    NSDictionary *contactDetailsDictionary = [_contactsData objectAtIndex:indexPath.row];
    [contactDetailVC setDictContactDetails:contactDetailsDictionary];
    
    [self.navigationController pushViewController:contactDetailVC animated:YES];
}

- (void)reload
{
    if (_contactsData == nil)
    {
        _contactsData = [[NSMutableArray alloc] init];
    }
    [_contactsData addObjectsFromArray:self.meeting.meetingMembers];
    NSLog(@"_count reload:  %lu", (unsigned long)_contactsData.count);
    
    [self.tableView reloadData];
}
@end
