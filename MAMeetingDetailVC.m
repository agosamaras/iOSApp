//
//  MAMeetingDetailVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAMeetingDetailVC.h"
#import "Meeting.h"
#import "MAEditMeetingNote.h"
#import "MAContactPickerVC.h"
#import "MAMeetingMapVC.h"

#import <GoogleMaps/GoogleMaps.h>

@interface MAMeetingDetailVC ()<GMSMapViewDelegate>

@property(strong, nonatomic) GMSMapView *meetingMapView;

@end

@implementation MAMeetingDetailVC

- (id)init
{
    self = [super init];
    if(self) {
        self.title = [NSString stringWithFormat:@"Meeting ID %ld",(long)self.meeting.meetingId];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                    target:self
                                                                                    action:@selector(editButtonTapped:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    
    self.meetingNameLabel = [[UILabel alloc] init];
    self.meetingNameLabel.backgroundColor = [UIColor clearColor];
    self.meetingNameLabel.textAlignment = NSTextAlignmentRight;
    
    UIFontDescriptor *helvetica24 = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue" size:24.0f];
    UIFontDescriptor *boldBase = [helvetica24 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    self.meetingNameLabel.font = [UIFont fontWithDescriptor:boldBase size:24.0f];
    
    self.meetingNameLabel.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.meetingNameLabel];
    
    self.functionBar = [[UIToolbar alloc] init];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *linkButton = [[UIBarButtonItem alloc] initWithTitle:@"Send Via Email"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(linkButtonTapped:)];
    [self.functionBar setItems:@[flexibleSpace, linkButton]];
    [self.scrollView addSubview:self.functionBar];
    
    self.notesView = [[UITextView alloc] init];
    self.notesView.editable = NO;
    UIFontDescriptor *helvetica22 = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue" size:22.0f];
    self.notesView.font = [UIFont fontWithDescriptor:helvetica22 size:22.0f];
    
    [self.scrollView addSubview:self.notesView];
    
    self.meetingDate = [[UITextView alloc] init];
    self.meetingDate.editable = NO;
    self.meetingDate.font = [UIFont fontWithDescriptor:helvetica22 size:22.0f];
    
    [self.scrollView addSubview:self.meetingDate];
    
    self.meetingMembersCount = [[UITextView alloc] init];
    self.meetingMembersCount.editable = NO;
    self.meetingMembersCount.font = [UIFont fontWithDescriptor:helvetica22 size:22.0f];
    
    [self.scrollView addSubview:self.meetingMembersCount];
    
    self.viewMeetingMembersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.viewMeetingMembersButton setTitle:@"View invitees" forState:UIControlStateNormal];
    self.viewMeetingMembersButton.tintColor = [UIColor orangeColor];
    
    [self.scrollView addSubview:self.viewMeetingMembersButton];
    
    [view addSubview:self.scrollView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    self.view.tintColor = [UIColor redColor];
    self.meetingNameLabel.text = self.meeting.name;
    
    NSLog(@"1st check Lat: %f and Lng: %f", self.meeting.meetingPoint.coordinate.latitude, self.meeting.meetingPoint.coordinate.longitude);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [NSString stringWithFormat:@"Details for %@", self.meeting.name];
    self.notesView.text = self.meeting.notes;
    self.meetingDate.text = (NSString *)self.meeting.date;
    self.meetingMembersCount.text = [NSString stringWithFormat: @"%ld", (long)self.meeting.meetingMembers.count];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0,
                                       0,
                                       CGRectGetWidth(self.view.frame),
                                       CGRectGetHeight(self.view.frame));
    
    ///////////////MAP//////////////////////////
    self.meetingMarker = [[GMSMarker alloc] init];
    
    self.meetingMarker.position = self.meeting.meetingPoint.coordinate;
    self.meetingMarker.title = self.meeting.venueName;
    self.meetingMarker.appearAnimation = kGMSMarkerAnimationPop;
    self.meetingMarker.icon = [UIImage imageNamed:@"marker-melt-house"];
    self.meetingMarker.userData = [UIImage imageNamed:@"melt-house"];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.meetingMarker.position.latitude
                                                            longitude:self.meetingMarker.position.longitude
                                                                 zoom:14
                                                              bearing:0
                                                         viewingAngle:0];
    
    self.meetingMapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                              0,
                                                              CGRectGetWidth(self.view.frame),
                                                              200)
                                            camera:camera];
    
    
    self.meetingMapView.mapType = kGMSTypeNormal;
    self.meetingMapView.myLocationEnabled = YES;
    self.meetingMapView.settings.compassButton = YES;
    self.meetingMapView.settings.myLocationButton = YES;
    self.meetingMapView.settings.zoomGestures = YES;
    self.meetingMapView.delegate = self;
    [self.meetingMapView setMinZoom:5 maxZoom:18];
    
    [self.scrollView addSubview:self.meetingMapView];
    
    self.meetingMarker.map = self.meetingMapView;
    ///////////////MAP//////////////////////////
    
    /*
    self.meetingImageView.frame = CGRectMake(self.topLayoutGuide.length + 100,
                                             0,
                                             CGRectGetWidth(self.scrollView.frame),
                                             200);
     */
    
    /*
    CGSize meetingNameLabelSize = [self.meetingNameLabel.text sizeWithAttributes:@{NSFontAttributeName: self.meetingNameLabel.font, UIFontDescriptorTraitsAttribute: @(UIFontDescriptorTraitBold)}];
    self.meetingNameLabel.frame = CGRectMake(CGRectGetWidth(self.view.frame) - meetingNameLabelSize.width - 20,
                                             CGRectGetMaxY(meetingMapView.frame) - 40,
                                             meetingNameLabelSize.width,
                                             meetingNameLabelSize.height);
    */
    
    self.functionBar.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.meetingMapView.frame),
                                        CGRectGetWidth(self.view.frame),
                                        44);

    
    self.notesView.frame = CGRectMake(10,
                                      CGRectGetMaxY(self.functionBar.frame) + 10,
                                      CGRectGetWidth(self.view.frame) - 10,
                                      140);
    self.meetingDate.frame = CGRectMake(10,
                                        CGRectGetMaxY(self.notesView.frame) + 10,
                                        CGRectGetWidth(self.view.frame) - 10,
                                        40);
    
    self.meetingMembersCount.frame = CGRectMake(10,
                                                CGRectGetMaxY(self.meetingDate.frame) + 10,
                                                CGRectGetWidth(self.scrollView.frame) - 10,
                                                40);
    self.viewMeetingMembersButton.frame = CGRectMake(CGRectGetMidX(self.view.frame)-50,
                                                     CGRectGetMaxY(self.meetingMembersCount.frame) + 10,
                                                     100,
                                                     50);
    [self.viewMeetingMembersButton addTarget:self
                                      action:@selector(viewMembers)
                            forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.viewMeetingMembersButton.frame)); //+ kViewPadding);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /*
    [self.notesView.layoutManager ensureLayoutForTextContainer:self.notesView.textContainer];
    CGRect notesViewRect = [self.notesView.layoutManager usedRectForTextContainer:self.notesView.textContainer];
    [self.meetingDate.layoutManager ensureLayoutForTextContainer:self.meetingDate.textContainer];
    CGRect meetingDateRect = [self.meetingDate.layoutManager usedRectForTextContainer:self.meetingDate.textContainer];
    
    CGRect updatedFrame = self.notesView.frame;
    updatedFrame.size.height = ceilf(notesViewRect.size.height + self.notesView.textContainerInset.top + self.notesView.textContainerInset.bottom);
    self.notesView.frame = updatedFrame;
    CGRect updatedFrame2 = self.meetingDate.frame;
    updatedFrame2.size.height = ceilf(meetingDateRect.size.height + self.meetingDate.textContainerInset.top + self.meetingDate.textContainerInset.bottom);
    self.meetingDate.frame = updatedFrame2;
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)editButtonTapped:(id)sender
{
    MAEditMeetingNote *maEditMeetingNote = [[MAEditMeetingNote alloc] init];
    maEditMeetingNote.meeting = self.meeting;
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:self.meeting.name
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:nil
                                                                              action:nil]];
    [self.navigationController  pushViewController:maEditMeetingNote animated:YES];
}


- (void)linkButtonTapped:(id)sender
{
    NSString *subject = self.meeting.name;
    
    NSString *body =[NSString stringWithFormat:@"Notes: %@\n Date: %@",self.meeting.notes,self.meetingDate.text];
    
    //NSString *body = self.meeting.notes;
    //NSString *date = self.meetingDate.text;
    NSArray *to = [NSArray arrayWithObject:@"nowhere@example.com"];
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    [composeVC setSubject:subject];
    [composeVC setMessageBody:body isHTML:NO];
    [composeVC setToRecipients:to];
    NSData *imageData = UIImagePNGRepresentation(self.meetingImageView.image);
    //[composeVC addAttachmentData:imageData mimeType:@"image/png" fileName:self.meeting.filename];
    
    [self presentViewController:composeVC animated:YES completion:nil];
}

- (void)viewMembers
{
    NSLog(@"viewMembers button tapped");
    MAContactPickerVC *contactPickerVC = [[MAContactPickerVC alloc] init];
    contactPickerVC.meeting = self.meeting;
    NSLog(@"Passed object count:  %lu", (unsigned long)contactPickerVC.meeting.meetingMembers.count);
    [self.navigationController pushViewController:contactPickerVC animated:YES];
    [contactPickerVC reload];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mapView:(GMSMapView *) mapView didLongPressAtCoordinate:(CLLocationCoordinate2D) coordinate
{
    NSLog(@"The map was tapped");
    MAMeetingMapVC *meetingMapVC = [[MAMeetingMapVC alloc] init];
    meetingMapVC.meetingMapView = self.meetingMapView;
    meetingMapVC.meetingMarker = self.meetingMarker;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:self.meeting.name
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:nil
                                                                              action:nil]];

    [self.navigationController pushViewController:meetingMapVC animated:YES];
}
@end