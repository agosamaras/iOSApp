//
//  MADatePickerVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 11/13/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MADatePickerVC.h"

@interface MADatePickerVC ()
@property (weak, nonatomic) IBOutlet UILabel *selectedDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@end

@implementation MADatePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myDatePicker addTarget:self
                          action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *dateValue = [dateFormatter stringFromDate:datePicker.date];
    self.selectedDate.text = dateValue;
    self.meeting.date = dateValue; //save the date value
}

@end
