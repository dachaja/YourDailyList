//
//  User.h
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-20.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookAuth;

@end
