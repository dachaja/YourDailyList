//
//  TableViewController.h
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-16.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong)   NSMutableArray *items;
@property (nonatomic)           BOOL useCustomCells;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property (nonatomic, strong)   NSMutableArray  *items;

@end

