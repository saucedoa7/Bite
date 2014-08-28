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

@end

@implementation CheckInToTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInTableCellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %d", indexPath.row + 1];

    self.tableNumber = cell.textLabel.text;
    NSLog(@"%@", self.tableNumber);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableCheckInCodeViewController *tableCheckInVC = segue.destinationViewController;
    tableCheckInVC.tableCode = self.tableCode;
    
}


@end
