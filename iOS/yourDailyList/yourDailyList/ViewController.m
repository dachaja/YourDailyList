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
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    NSLog(@"loginViewShowingLoggedInUser");
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *status = [defaults objectForKey:@"status"];
//    NSString *userId = [defaults objectForKey:@"userId"];
//   
//    if(status == nil) {
//        // first time login
//        NSLog(@"First time login.");
//        [self createUser:defaults];
//
//    } else if([status isEqualToString:@"verifying"]) {
//        // login with new user
//        NSLog(@"Login with new user");
//        [self createUser:defaults];
//
//    } else if (userId != nil) {
//        // Login Auth is done.
//
//    } else {
//        return;
//    }
//    
//    // Go to TableView
//    NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
//    [self.view addSubview:navController.view];
//    [self addChildViewController:navController];
//    
//}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *email = [defaults objectForKey:@"email"];
    NSString *userId = [defaults objectForKey:@"userId"];
    
    if(email == nil) {
        // first time login
        [defaults setObject:[user objectForKey:@"email"] forKey:@"email"];
        [defaults synchronize];
        
        [self createUser:defaults];
    } else if(![email isEqualToString:[user objectForKey:@"email"]]) {
        // login with new user
        [defaults setObject:[user objectForKey:@"email"] forKey:@"email"];
        [defaults synchronize];

        [self createUser:defaults];
    }
    
    if(userId != nil) {
        // Go to TableView
        NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
        [self.view addSubview:navController.view];
        [self addChildViewController:navController];
    }
}

#pragma mark - AFNetworking
- (void) createUser:(NSUserDefaults *)defaults {
    
    NSString *email = [defaults objectForKey:@"email"];
    if(email == nil) return;
    
    AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary    *params = @{@"email": email, @"facebookAuth":@"true"};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"http://127.0.0.1:9000/yourdailylist/v0/auth/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSDictionary *dictionary = [arr objectAtIndex:0];
        
        NSLog(@"success %@",responseObject);
        [defaults setObject:[dictionary objectForKey:@"email"] forKey:@"email"];
        [defaults setObject:[dictionary objectForKey:@"userId"]  forKey:@"userId"];
        [defaults synchronize];
        
        NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
        [self.view addSubview:navController.view];
        [self addChildViewController:navController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    NSLog(@"%@", manager.baseURL.relativePath);
}


@end
