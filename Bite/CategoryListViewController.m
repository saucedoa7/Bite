//
//  CategoryListViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CategoryListViewController.h"
#import "FoodDetailsViewController.h"
#import "CategoryListTableViewCell.h"

@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSArray *foodItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CategoryListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.2 alpha:1];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    PFQuery *foodListQuery = [PFQuery queryWithClassName:@"Food"];
    [foodListQuery whereKey:@"category" equalTo:self.categorySelected];
    [foodListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.foodItems = objects;
        [self.tableView reloadData];

    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryListCellID"];
    PFObject *foodItem = self.foodItems[indexPath.row];
    cell.itemName.text = [foodItem objectForKey:@"foodItem"];
    cell.itemPrice.text = [NSString stringWithFormat:@"%@",[foodItem objectForKey:@"price"]];

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foodItems.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (IBAction)unwindToCategoryVC:(UIStoryboardSegue *)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PFObject *object = [self.foodItems objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    FoodDetailsViewController *foodDetailVC = segue.destinationViewController;
    foodDetailVC.foodItemSelected = object;
    foodDetailVC.tableNumber = self.tableNumber;


}



@end
