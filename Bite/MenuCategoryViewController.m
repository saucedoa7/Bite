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
@property NSArray *categories;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.2 alpha:1];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Category"];
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.categories = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];

//    PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Food"];
//    [categoryQuery whereKey:@"Category" equalTo:self.resaurantObject];
//    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (objects) {
//            self.categories = [objects mutableCopy];
//            [self.tableView reloadData];
//        }
//    }];

    [self.tabBarController setTitle:@"Menu"];


}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCategoryCellID"];
    PFObject *category = self.categories[indexPath.row];
    cell.courseName.text = [category objectForKey:@"name"];
    return cell;
}

-(IBAction)unwindToMenuCatagory:(UIStoryboardSegue*)sender
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoryListViewController *categoryVC = segue.destinationViewController;
    PFObject *category = self.categories[self.tableView.indexPathForSelectedRow.row];

    categoryVC.categorySelected = category;
    categoryVC.tableNumber = self.tableNumber;
}
@end
