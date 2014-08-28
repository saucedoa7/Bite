//
//  CheckInToTableViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CheckInToTableViewController.h"
#import "TableCheckInCodeViewController.h"

@interface CheckInToTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSNumber *numberOfTables;
@property NSString *tableCode;

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

    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %li", indexPath.row + 1];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableCheckInCodeViewController *tableCheckInVC = segue.destinationViewController;
//    tableCheckInVC.tableCode = self.tableCode;
    tableCheckInVC.restaurantObject = self.restaurantObject;

}


@end
