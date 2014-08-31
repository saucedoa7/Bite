//
//  CheckInToTableViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CheckInToTableViewController.h"
#import "TableCheckInCodeViewController.h"
#import "CurrentBillViewController.h"
#import "TabBarController.h"

@interface CheckInToTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *checkInTableView;
@property NSNumber *numberOfTables;
@property NSMutableArray *numberOfTablesMute;
@property NSString *tableCode;
@property int tableNumber;
@property NSMutableArray* sectionsArray;
@end

@implementation CheckInToTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.numberOfTables = [self.restaurantObject objectForKey:@"numberOfTables"];

    self.sectionsArray = [NSMutableArray new];
    [self.sectionsArray addObject:[NSString stringWithFormat:@"Section: %d", self.sectionsArray.count]];

#pragma mark CheckinTableView Data

    [[self checkInTableView] setDelegate:self];
    [[self checkInTableView] setDataSource:self];
    [[self checkInTableView] reloadData];
}

#pragma mark Table View delegations

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.numberOfTables.intValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInTableCellID"];

    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %d", indexPath.row + 1];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkInTableCellID"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.numberOfTablesMute [sourceIndexPath.row];
    [self.numberOfTablesMute removeObjectAtIndex:sourceIndexPath.row];
    [self.numberOfTablesMute insertObject:stringToMove atIndex:destinationIndexPath.row];
}

#pragma mark Drag Cells

//Drag Cells 1
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//Drag Cells 2
- (IBAction)onEditButton:(UIBarButtonItem *)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.checkInTableView setEditing:NO animated:NO];
        [self.checkInTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.checkInTableView setEditing:YES animated:YES];
        [self.checkInTableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

#pragma mark Add Section


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionsArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionsArray objectAtIndex:section];
}

#pragma mark Remove delete button

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    TableCheckInCodeViewController *tableCheckInVC = segue.destinationViewController;
    int index = [self.checkInTableView indexPathForSelectedRow].row + 1;
    tableCheckInVC.tableNumber = index;
    tableCheckInVC.restaurantObject = self.restaurantObject;

    [self.checkInTableView indexPathForCell:sender];
}

@end
