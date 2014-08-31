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
@property NSNumber *numberOfTables;
@property (weak, nonatomic) IBOutlet UITableView *checkInTableView;
@property NSString *tableCode;
@property int tableNumber;

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
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfTables.intValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInTableCellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %d", indexPath.row + 1];
    return cell;
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
