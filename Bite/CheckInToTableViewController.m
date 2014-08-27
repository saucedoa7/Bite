//
//  CheckInToTableViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CheckInToTableViewController.h"

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
    int x;
    for (x = 0; x < self.numberOfTables.intValue; x++) {
        cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %d", x];
    }

    return cell;
}


@end
