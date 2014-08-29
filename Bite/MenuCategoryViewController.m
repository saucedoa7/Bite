//
//  MenuCategoryViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "MenuCategoryViewController.h"
#import "MenuCategoryTableViewCell.h"
#import "CategoryListViewController.h"

@interface MenuCategoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *restaurantDetailArray;
@property NSArray *menuCategory;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuCategoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.restaurantDetailArray = [NSMutableArray new];


    PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Food"];
    [categoryQuery whereKey:@"restaurant" equalTo:self.resaurantObject];
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.restaurantDetailArray = [objects mutableCopy];
            self.menuCategory = [self.restaurantDetailArray valueForKey:@"category"] ;
            [self.tableView reloadData];
        }

    }];


}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCategoryCellID"];
    cell.courseName.text = self.menuCategory [indexPath.row];

    return cell;
}

-(IBAction)unwindToMenuCatagory:(UIStoryboardSegue*)sender
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoryListViewController *categoryVC = segue.destinationViewController;
    categoryVC.categorySelected = [self.menuCategory objectAtIndex:self.tableView.indexPathForSelectedRow.row];


}
@end
