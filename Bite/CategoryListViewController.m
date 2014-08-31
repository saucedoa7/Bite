//
//  CategoryListViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CategoryListViewController.h"
#import "FoodDetailsViewController.h"

@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *categoryList;
@property NSArray *foodItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CategoryListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.categoryList = [NSMutableArray new];
    PFQuery *foodListQuery = [PFQuery queryWithClassName:@"Food"];
    [foodListQuery whereKey:@"category" equalTo:self.categorySelected];
    [foodListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.categoryList = [objects mutableCopy];
        self.foodItems = [self.categoryList valueForKey:@"foodItem"];
        [self.tableView reloadData];

    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryListCellID"];
    cell.textLabel.text = self.foodItems [indexPath.row];

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foodItems.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PFObject *object = [self.categoryList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    FoodDetailsViewController *foodDetailVC = segue.destinationViewController;
    foodDetailVC.foodItemSelected = object;


}



@end
