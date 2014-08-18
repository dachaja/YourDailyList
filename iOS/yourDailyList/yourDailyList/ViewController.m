//
//  ViewController.m
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-14.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "NavController.h"
#import <AFNetworking/AFNetworking.h>

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"email"];
    NSString *status = [defaults objectForKey:@"status"];
    
    if(email != nil && [status isEqualToString:@"verifying"]) {
        //Send email to WAS
        AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary    *params = @{@"email": email, @"facebookAuth":@"true"};
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        [manager POST:@"http://127.0.0.1:9000/yourdailylist/v0/auth/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@",responseObject);
            [defaults setObject:@"verified" forKey:@"status"];
            [defaults synchronize];
            
            NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
            [self.view addSubview:navController.view];
            [self addChildViewController:navController];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    
        NSLog(@"%@", manager.baseURL.relativePath);
    
    } else {
        NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
        [self.view addSubview:navController.view];
        [self addChildViewController:navController];
    }
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *email = [defaults objectForKey:@"email"];
    if(![email isEqualToString:[user objectForKey:@"email"]]) {
        [defaults setObject:[user objectForKey:@"email"] forKey:@"email"];
        [defaults setObject:@"verifying" forKey:@"status"];
        [defaults synchronize];
    }

}


@end
