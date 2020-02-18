//
//  MAProfileVC.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "MAProfileVC.h"

#define kViewPadding 25.0f

@interface MAProfileVC ()

@end

@implementation MAProfileVC

- (id)init
{
    self = [super init];
    if(self) {
        self.title = @"My profile";
        self.tabBarItem.image = [UIImage imageNamed:@"CS-tabBar"];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.40 green:0.71 blue:0.9 alpha:1.0];
    
    self.contentSubview = [[UIScrollView alloc] init];
    
    self.headerLabel = [[UILabel alloc] init];
    self.authorLabel = [[UILabel alloc] init];
    
    
    UIFontDescriptor *futura40 = [UIFontDescriptor fontDescriptorWithName:@"Futura" size:40.0f];
    UIFontDescriptor *futura40Condensed = [futura40 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
    UIFontDescriptor *futura40CondensedBold = [futura40Condensed fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    self.headerLabel.font = [UIFont fontWithDescriptor:futura40CondensedBold size:futura40CondensedBold.pointSize];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.textColor = [UIColor whiteColor];
    
    UIFontDescriptor *helvetica20 = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue" size:20];
    self.authorLabel.font = [UIFont fontWithDescriptor:helvetica20 size:20];
    self.authorLabel.backgroundColor = [UIColor clearColor];
    self.authorLabel.textColor = [UIColor whiteColor];
    
    [self.contentSubview addSubview:self.headerLabel];
    [self.contentSubview addSubview:self.authorLabel];
    
    
    self.descriptionTextView = [[UITextView alloc] init];
    
    UIFontDescriptor *body = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    self.descriptionTextView.font = [UIFont fontWithDescriptor:body size:0];
    
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [UIColor whiteColor];
    self.descriptionTextView.editable = NO;
    [self.contentSubview addSubview:self.descriptionTextView];
    
    self.csInfoTextView = [[UITextView alloc] init];
    
    self.csInfoTextView.font = [UIFont fontWithDescriptor:body size:0];
    self.csInfoTextView.backgroundColor = [UIColor clearColor];
    self.csInfoTextView.textColor = [UIColor whiteColor];
    self.csInfoTextView.editable = NO;
    [self.contentSubview addSubview:self.csInfoTextView];
    
    [view addSubview:self.contentSubview];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowOffset = CGSizeMake(2, 2);
    textShadow.shadowBlurRadius = 4.0;
    
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:@"PhotoNotes" attributes:@{NSShadowAttributeName: textShadow}];
    self.headerLabel.attributedText = headerText;
    
    self.authorLabel.text = @"Created by";
    self.descriptionTextView.text = @"PhotoNotes is a simple app created for Code School's Core iOS 7 course.  If you install this app on your phone then you will be able to take photos and add some notes about them.  For example, you might take a picture of a tree and leave a note about why you found that tree worthy of capturing.";
    
    self.csInfoTextView.text = @"Code School teaches web and app development technologies in the comfort of your browser with video lessons, coding challenges, and screencasts.  With the release of iOS 7, we're now expanding our code challenges to the environment that most iOS developers work in - Xcode.  By completing challenges in Xcode and still earning points and badges on codeschool.com, we're able to bring you the best of both worlds so you can start building apps quickly. We strive to help you learn by doing.";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeChanged:)
                                                 name:@"UIContentSizeCategoryDidChangeNotification"
                                               object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.contentSubview.frame = CGRectMake(0,
                                           0,
                                           CGRectGetWidth(self.view.frame),
                                           CGRectGetHeight(self.view.frame));
    
    self.headerLabel.frame = CGRectMake(20,
                                        5,
                                        280,
                                        self.headerLabel.font.pointSize + 5);
    
    self.authorLabel.frame = CGRectMake(30,
                                        CGRectGetMaxY(self.headerLabel.frame) + kViewPadding + 5,
                                        100,
                                        self.authorLabel.font.pointSize);
    
    self.csLogoButton.frame = CGRectMake(140,
                                         CGRectGetMaxY(self.headerLabel.frame) + kViewPadding,
                                         self.csLogoButton.imageView.image.size.width,
                                         self.csLogoButton.imageView.image.size.height);
    
    self.descriptionTextView.frame = CGRectMake(20,
                                                CGRectGetMaxY(self.csLogoButton.frame) + kViewPadding,
                                                280,
                                                160);
    
    self.csInfoTextView.frame = CGRectMake(20,
                                           CGRectGetMaxY(self.descriptionTextView.frame) + kViewPadding,
                                           280,
                                           300);
    
    self.contentSubview.contentSize = CGSizeMake(CGRectGetWidth(self.contentSubview.frame), CGRectGetMaxY(self.csInfoTextView.frame) + kViewPadding);
}

- (void)viewDidLayoutSubviews
{
    [self.descriptionTextView.layoutManager ensureLayoutForTextContainer:self.descriptionTextView.textContainer];
    CGRect descriptionTextViewRect = [self.descriptionTextView.layoutManager usedRectForTextContainer:self.descriptionTextView.textContainer];
    
    CGRect descriptionTextViewFrame = self.descriptionTextView.frame;
    descriptionTextViewFrame.size.height = ceilf(descriptionTextViewRect.size.height + self.descriptionTextView.textContainerInset.top + self.descriptionTextView.textContainerInset.bottom);
    self.descriptionTextView.frame = descriptionTextViewFrame;
    
    [self.csInfoTextView.layoutManager ensureLayoutForTextContainer:self.csInfoTextView.textContainer];
    CGRect csInfoTextViewRect = [self.csInfoTextView.layoutManager usedRectForTextContainer:self.csInfoTextView.textContainer];
    
    CGRect csInfoTextViewFrame = self.csInfoTextView.frame;
    csInfoTextViewFrame.origin.y = CGRectGetMaxY(self.descriptionTextView.frame) + kViewPadding;
    csInfoTextViewFrame.size.height = ceilf(csInfoTextViewRect.size.height + self.csInfoTextView.textContainerInset.top + self.csInfoTextView.textContainerInset.bottom);
    self.csInfoTextView.frame = csInfoTextViewFrame;
    
    self.contentSubview.contentSize = CGSizeMake(CGRectGetWidth(self.contentSubview.frame), CGRectGetMaxY(self.csInfoTextView.frame) + kViewPadding);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)contentSizeChanged:(id)sender
{
    UIFontDescriptor *bodyFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    self.descriptionTextView.font = [UIFont fontWithDescriptor:bodyFont size:0];
    self.csInfoTextView.font = [UIFont fontWithDescriptor:bodyFont size:0];
    [self.view setNeedsLayout];
}
@end
