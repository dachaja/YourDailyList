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
#import <AFNetworking/AFNetworking.h>
#import "List.h"
#import "User.h"
#import "AppDelegate.h"

@interface TableViewController ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray   *fetchedUserArray;
@property (nonatomic, strong) NSArray   *fetchedListArray;
@property (nonatomic, strong) NSFetchedResultsController        *fetchedResultsController;
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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedResultsController = appDelegate.fetchedResultsController;
    
    //Fetching Users, Lists
    self.fetchedUserArray = [appDelegate getUserEntity];
    self.fetchedListArray = [appDelegate getListEntity];
    
    self.items = [[NSMutableArray alloc] init];
    for(List *list in self.fetchedListArray) {
        [self.items addObject:list];
    }
    
    
    // Setup refresh control for example app
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(toggleCells:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor blueColor];
    
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    //_items = [[NSMutableArray alloc] init];
    _useCustomCells = NO;
    
    [self readAllList];
    
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
    return [self.items count];
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
    
    List *list = [self.items objectAtIndex:indexPath.row];
    
    cell.itemLabel.text = list.title;
    if([list.mark isEqualToString:@"YES"])
        cell.checkImageView.image = [UIImage imageNamed:@"btn_checked.png"];
    else
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
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:selectedCell];
    
    if(selectedCell.checkImageView.tag == 0) {
        selectedCell.checkImageView.image = [UIImage imageNamed:@"btn_checked.png"];
        selectedCell.checkImageView.tag = 1;
        [self updateListEntryWithMark:@"YES" indexPath:cellIndexPath];
    } else {
        selectedCell.checkImageView.image = [UIImage imageNamed:@"btn_unchecked.png"];
        selectedCell.checkImageView.tag = 0;
        [self updateListEntryWithMark:@"NO" indexPath:cellIndexPath];
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
    NSString    *title = [[alertView textFieldAtIndex:0] text];
    
    [self addListEntryWithTitle:title];
    [self.tableView reloadData];
    [self createList:title];
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
            
            List *selectedList = [self.fetchedListArray objectAtIndex:index];
            [self.managedObjectContext deleteObject:selectedList];
            [self.managedObjectContext save:nil];
            
            [self.items removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

#pragma mark - AFNetworking
- (void) readAllList {
    User *userEntity = [self.fetchedUserArray objectAtIndex:0];
    
    //GET
    AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString    *url    = [NSString stringWithFormat:@"http://54.191.234.40:9000/yourdailylist/v0/list/%@", userEntity.userId];
    
    [manager GET:url
            parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@", responseObject);
                if ([dictionary count] > 0) {
                    // Delete previous Core Data
                    for(List *entity in self.fetchedListArray) {
                        [self.managedObjectContext deleteObject:entity];
                    }
                    [self.managedObjectContext save:nil];
                    [self.items removeAllObjects];
                    
                    // Update Table view
                    for (NSDictionary *list in dictionary) {
                        [self addListEntryWithAll:list];
                    }
                    [self.tableView reloadData];
                    // Core Data.
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void) createList:(NSString *)title {
    User *userEntity = [self.fetchedUserArray objectAtIndex:0];
    NSString    *userId = userEntity.userId;
    
    AFHTTPRequestOperationManager   *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary    *params = @{@"userId":userId, @"title":title, @"mark":@"NO"};
   
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString    *url    = [NSString stringWithFormat:@"http://54.191.234.40:9000/yourdailylist/v0/list/"];
    
    [manager POST:url
            parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
             
                NSString   *result = [dictionary objectForKey:@"createList"];
                if([result isEqualToString:@"sucess"]) {
                    NSLog(@"Create a list successfully.");
                } else {
                    NSLog(@"Failed to create a list");
                }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    
    // Update Core Data.
}

#pragma mark - Core Data Handler
- (void) addListEntryWithTitle:(NSString *)title {
    List    *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    newList.title = title;
    
    User    *userEntity = [self.fetchedUserArray objectAtIndex:0];
    newList.userId = [NSString stringWithFormat:@"%@",userEntity.userId];
    newList.mark = NO;
    
    [self.managedObjectContext save:nil];
    [self.items addObject:newList];
    
    [self.tableView reloadData];
}

- (void) addListEntryWithAll:(NSDictionary *)dic {
    List    *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    newList.title = [dic objectForKey:@"title"];
    newList.userId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"userId"]];
    newList.listId =[NSString stringWithFormat:@"%@", [dic objectForKey:@"listId"]];
    newList.mark = [dic objectForKey:@"mark"];
    
    [self.managedObjectContext save:nil];
    [self.items addObject:newList];
}

- (void) updateListEntryWithMark:(NSString *) mark indexPath:(NSIndexPath *)indexPath{
    //upate mark.
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
