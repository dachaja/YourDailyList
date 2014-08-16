//
//  ViewController.m
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-14.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    FBLoginView     *loginView = [[FBLoginView alloc] initWithPublishPermissions:@[@"public_profile",@"email",@"user_friends"] defaultAudience:FBSessionDefaultAudienceEveryone];
    loginView.delegate = self;
    
    loginView.frame = CGRectOffset(loginView.frame, 55, 400);
    [self.view addSubview:loginView];
    [loginView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginViewDelegate
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedInUser");
    TableViewController *tableView = [[TableViewController alloc]init];
    [self.view addSubview:tableView.view];
}


@end
