//
//  AppDelegate.m
//  MeetApp
//
//  Created by Λεανδρος Τζανακης on 10/24/14.
//  Copyright (c) 2014 Λεανδρος Τζανακης. All rights reserved.
//

#import "AppDelegate.h"

#import "Meeting.h"
#import "Meetings.h"

#import "MAMeetingListVC.h"
#import "MAMeetingDetailVC.h"
#import "MACreateMeetingVC.h"
#import "MAProfileVC.h"

#import "BZFoursquare.h"

#import <GoogleMaps/GoogleMaps.h>

#define kWipeEverythingOnNextLoad 0

@implementation AppDelegate


//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    UINavigationController *navigationController = (UINavigationController *)_window.rootViewController;
//    FSQMasterViewController *masterViewController = navigationController.viewControllers[0];
//    BZFoursquare *foursquare = masterViewController.foursquare;
//    return [foursquare handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyAhYJVkO_wvyWjQxPRi4nVxLMS0aDJuuvY"]; //token_nIX1*191
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    /*
    self.window.frame =  CGRectMake(0,
                                    20,
                                    self.window.frame.size.width,
                                    self.window.frame.size.height-20);
     */   
    
    if(kWipeEverythingOnNextLoad) {
        Meetings *meetings = nil;
        [Meetings saveMeetingsToArchive:meetings];
    }
    
    if([Meetings getMeetingsFromArchive] == nil) {
        [self setupInitialImageData];
    } else {
        NSLog(@"initial images already loaded");
    }
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    MAMeetingListVC *meetingListVC = [[MAMeetingListVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:meetingListVC];
    
    MACreateMeetingVC *createMeetingVC = [[MACreateMeetingVC alloc] init];
    UINavigationController *navCreateMeetingController = [[UINavigationController alloc] initWithRootViewController:createMeetingVC];
    
    MAProfileVC *profileVC = [[MAProfileVC alloc] init];
    
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    
    tabBarController.viewControllers = @[navController, navCreateMeetingController, profileNav];
    
    self.window.rootViewController = tabBarController;
    
    self.window.tintColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.5 alpha:1.0];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navCreateMeetingController.navigationBar.barStyle = UIBarStyleBlack;
    profileNav.navigationBar.barStyle = UIBarStyleBlack;
    tabBarController.tabBar.barStyle = UIBarStyleBlack;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupInitialImageData
{
    NSArray *meetingsFromMlist;
    NSString *mlist = [[NSBundle mainBundle] pathForResource:@"initialData" ofType:@"mlist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:mlist]) {
        meetingsFromMlist = [[NSArray alloc] initWithContentsOfFile:mlist];
        
        NSMutableArray *meetingsArray = [[NSMutableArray alloc] initWithCapacity:meetingsFromMlist.count];
        [meetingsFromMlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Meeting *meeting = [[Meeting alloc] init];
            meeting.meetingId = [meetingsFromMlist[idx][@"id"] integerValue];
            meeting.name = meetingsFromMlist[idx][@"name"];
            //meeting.filename = meetingsFromMlist[idx][@"filename"];
            meeting.notes = meetingsFromMlist[idx][@"notes"];
            
            [meetingsArray addObject:meeting];
        }];
        
        Meetings *meetings = [[Meetings alloc] init];
        meetings.allMeetings = [[NSArray alloc] initWithArray:meetingsArray];
        [Meetings saveMeetingsToArchive:meetings];
    } else {
        NSLog(@"file doesn't exist");
    }
}

@end