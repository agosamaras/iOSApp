//
//  MAProfileVC.h
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAProfileVC : UIViewController

@property (strong, nonatomic) UIScrollView *contentSubview;

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UIButton *csLogoButton;
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) UITextView *csInfoTextView;

- (void)contentSizeChanged:(id)sender;

@end