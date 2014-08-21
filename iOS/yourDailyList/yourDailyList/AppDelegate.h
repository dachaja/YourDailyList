//
//  AppDelegate.h
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-14.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel    *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;
@property (nonatomic, strong)   NSFetchedResultsController      *fetchedResultsController;

-(NSArray *)getUserEntity;
-(NSArray *)getListEntity;

@end
