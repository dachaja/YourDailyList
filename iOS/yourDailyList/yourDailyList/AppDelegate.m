//
//  AppDelegate.m
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-14.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel   = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
@synthesize fetchedResultsController = _fetchedResultsController;

// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

#pragma mark - Core Data Handler.
- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator    *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if(_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"List.sqlite"]];
    NSError *error = nil;
    
    NSDictionary    *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Error for store creation should be handled in here.
    }
    return _persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSArray *)getUserEntity {
    NSFetchRequest  *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:userEntity];
    
    NSArray *fetchedUsers = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return fetchedUsers;
}

- (NSArray *)getListEntity {
    NSFetchRequest  *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor    *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listId" ascending:YES];
    NSArray         *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription *listEntity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:listEntity];
    [fetchRequest setSortDescriptors:sortDescriptors];;
    
    NSArray *fetchedLists = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedLists;
}

@end
