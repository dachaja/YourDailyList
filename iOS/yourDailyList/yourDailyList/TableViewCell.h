//
//  TableViewCell.h
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-16.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface TableViewCell : SWTableViewCell

@property   (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property   (strong, nonatomic) IBOutlet UIImageView *checkImageView;
@end
