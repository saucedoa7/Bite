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


    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %ld", indexPath.row + 1];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInTableCellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %ld", indexPath.row + 1];

    CurrentBillViewController *VCBill = [[CurrentBillViewController alloc] initWithNibName:@"CurrentBillViewController" bundle:nil];

    VCBill.oneTableNumber = cell.textLabel.text;

    NSLog(@"%@", VCBill.oneTableNumber);

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"codeEnteredSegue"]) {
        TabBarController *VCBillPass = [segue destinationViewController];
    }

    TableCheckInCodeViewController *tableCheckInVC = segue.destinationViewController;
//    tableCheckInVC.tableCode = self.tableCode;
    tableCheckInVC.restaurantObject = self.restaurantObject;

}


@end
