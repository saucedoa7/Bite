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
    NSLog(@"cell for row %d", self.tableNumber);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tableNumber = indexPath.row +1;
    NSLog(@"did select  %d", self.tableNumber);
    [self performSegueWithIdentifier:@"tableCheckInSegue" sender:self];

}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.tableNumber = indexPath.row +1;
//    return indexPath.row;
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableCheckInCodeViewController *tableCheckInVC = segue.destinationViewController;
    int index = [self.checkInTableView indexPathForSelectedRow].row;
    tableCheckInVC.tableNumber = index;
    tableCheckInVC.restaurantObject = self.restaurantObject;
    tableCheckInVC.tableNumber = self.tableNumber;
    NSLog(@"tableCheckinVC %d", tableCheckInVC.tableNumber);

    //Grab the indexpath of sender, by asking the self.tableview

    [self.checkInTableView indexPathForCell:sender];
    NSLog(@"SENDER %@", sender);

    //assign that indexpath.row +1 to self.tablenumber

    //    TableCheckInCodeViewController *tableCheckInVCC = [[TableCheckInCodeViewController alloc] initWithNibName:@"TableCheckInCodeViewController" bundle:nil];
    //    tableCheckInVCC.tableNumber = self.tableNumber;
}

@end
