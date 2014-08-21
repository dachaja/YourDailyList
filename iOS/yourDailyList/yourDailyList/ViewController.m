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
#import "User.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContext;
@property (nonatomic, strong) NSArray   *fetchedUserArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //Fetching Users
    self.fetchedUserArray = [appDelegate getUserEntity];
    
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
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
    
    NSString *email = [user objectForKey:@"email"];
    
    if (self.fetchedUserArray.count == 0) {
        // first time login
        [self createUser:email];
        
        return;
    }
    
    User    *userEntity = [self.fetchedUserArray objectAtIndex:0];
    if(![userEntity.email isEqualToString:[user objectForKey:@"email"]]){
        // loggedIn New User.
        // Delete previous userEntity.
        for(User *entity in self.fetchedUserArray) {
            [self.managedObjectContext deleteObject:entity];
        }
        [self.managedObjectContext save:nil];
        [self createUser:email];
        
        return;
    }
    NSLog(@"%@", userEntity.userId);
    if(userEntity.userId != nil) {
        // Go to TableView
        NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
        [self.view addSubview:navController.view];
        [self addChildViewController:navController];
    }
}

#pragma mark - AFNetworking
- (void) createUser:(NSString *)email {

    if(email == nil) return;
    
    AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary    *params = @{@"email": email, @"facebookAuth":@"true"};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"http://54.191.234.40:9000/yourdailylist/v0/auth/"
            parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"success %@",responseObject);
                
                // Add User Entity.
                if(self.fetchedUserArray.count == 0)
                    [self addUserEntry:dictionary];
        
                // Go to TableView
                NavController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
                [self.view addSubview:navController.view];
                [self addChildViewController:navController];
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"failure");
    }];
    
}

#pragma mark - Core Data Handler
- (void) addUserEntry:(NSDictionary *)user {
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    newUser.userId = [user objectForKey:@"userId"];
    newUser.email = [user objectForKey:@"email"];
    newUser.facebookAuth = [user objectForKey:@"facebookAuth"];
    
    [self.managedObjectContext save:nil];
}


@end
