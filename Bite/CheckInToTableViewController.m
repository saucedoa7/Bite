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
#import "CheckInToTableTableViewCell.h"

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
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.numberOfTables = [self.restaurantObject objectForKey:@"numberOfTables"];

    self.sectionsArray = [NSMutableArray new];
    [self.sectionsArray addObject:[NSString stringWithFormat:@"Section: %lu", (unsigned long)self.sectionsArray.count]];

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
    CheckInToTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInTableCellID"];

    cell.tableLabel.text = [NSString stringWithFormat:@"Table Number: %d", indexPath.row + 1];

    if (!cell) {
        cell = [[CheckInToTableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkInTableCellID"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.numberOfTablesMute [sourceIndexPath.row];
    [self.numberOfTablesMute removeObjectAtIndex:sourceIndexPath.row];
    [self.numberOfTablesMute insertObject:stringToMove atIndex:destinationIndexPath.row];
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
