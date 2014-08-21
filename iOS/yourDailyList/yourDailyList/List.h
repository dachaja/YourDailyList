//
//  List.h
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-20.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSString * listId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * mark;

@end
