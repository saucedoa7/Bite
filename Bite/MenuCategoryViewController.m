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

    PFQuery *food = [PFQuery queryWithClassName:@"Food"];
    [food whereKey:@"restaurant" equalTo:self.resaurantObject];
    [food findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            NSMutableSet *set = [NSMutableSet new];
            for (PFObject *food in objects) {
                PFObject *ob = [food objectForKey:@"category"];
                [set addObject:ob.objectId];
            }
            NSMutableArray *arr = [NSMutableArray new];
            __block int count = 0;

            for (NSString *catID in set) {
                PFQuery *query = [PFQuery queryWithClassName:@"Category"];
                [query getObjectInBackgroundWithId:catID block:^(PFObject *object, NSError *error) {
                    count++;
                    [arr addObject:object];
                    if (count == set.count) {
                        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                        self.categories = [arr sortedArrayUsingDescriptors:@[sort]];
                        [self.tableView reloadData];
                    }
                }];
            }


        }
    }];


    [self.tabBarController setTitle:@"Menu"];


}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCategoryCellID"];
    PFObject *cat = self.categories[indexPath.row];
    cell.courseName.text = [cat objectForKey:@"name"];
    return cell;
}

-(IBAction)unwindToMenuCatagory:(UIStoryboardSegue*)sender
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoryListViewController *categoryVC = segue.destinationViewController;

    categoryVC.categorySelected = [self.categories objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    categoryVC.tableNumber = self.tableNumber;
    categoryVC.restaurant = self.resaurantObject;
}
@end
