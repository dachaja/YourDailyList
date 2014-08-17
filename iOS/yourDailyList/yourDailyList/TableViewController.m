//
//  TableViewController.m
//  yourDailyList
//
//  Created by Ahyeon Jo Pettit on 2014-08-16.
//  Copyright (c) 2014 Anna Jo Pettit. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "SWTableViewCell.h"
#import "ViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup refresh control for example app
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(toggleCells:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor blueColor];
    
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    _items = [[NSMutableArray alloc] init];
    [_items addObjectsFromArray:@[@"First",@"Second",@"Third",@"Fourth"]];

    _useCustomCells = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIRefreshControl Selector
- (void)toggleCells:(UIRefreshControl*)refreshControl {
    [refreshControl beginRefreshing];
    self.useCustomCells =! self.useCustomCells;
    if (self.useCustomCells) {
        self.refreshControl.tintColor = [UIColor yellowColor];
    } else {
        self.refreshControl.tintColor = [UIColor blueColor];
    }
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableCell"];

    if(cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    //[cell setLeftUtilityButtons:[self leftButtons]];
    [cell setRightUtilityButtons:[self rightButtons]];
    cell.delegate = self;
    
    cell.itemLabel.text = [_items objectAtIndex:indexPath.row];
    cell.checkImageView.image = [UIImage imageNamed:@"btn_unchecked.png"];
    cell.checkImageView.tag = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [cell.checkImageView addGestureRecognizer:tap];
    cell.checkImageView.userInteractionEnabled = YES;
    
    return cell;
}

#pragma mark - TapGestureRecognizer
- (void) tapHandler:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapLocation = [tapRecognizer locationInView:self.tableView];
    NSIndexPath *tappedIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    TableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:tappedIndexPath];
    
    if(selectedCell.checkImageView.tag == 0) {
        selectedCell.checkImageView.image = [UIImage imageNamed:@"btn_checked.png"];
        selectedCell.checkImageView.tag = 1;
    } else {
        selectedCell.checkImageView.image = [UIImage imageNamed:@"btn_unchecked.png"];
        selectedCell.checkImageView.tag = 0;
    }
}

#pragma mark - SWTableViewButtons

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"Delete"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                    title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark - addNewItem
- (IBAction)addNewItem:(id)sender {
    UIAlertView *addNewItem = [[UIAlertView alloc] initWithTitle:@"New Item" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    addNewItem.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addNewItem show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) return;
    
    [_items addObject:[[alertView textFieldAtIndex:0] text]];
    [self.tableView reloadData];
}

#pragma mark - SWTableViewDelegate

//- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
//{
//    switch (state) {
//        case 0:
//            NSLog(@"utility buttons closed");
//            break;
//        case 1:
//            NSLog(@"left utility buttons open");
//            break;
//        case 2:
//            NSLog(@"right utility buttons open");
//            break;
//        default:
//            break;
//    }
//}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [_items removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
