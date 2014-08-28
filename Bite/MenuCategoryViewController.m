//
//  MenuCategoryViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "MenuCategoryViewController.h"
#import "MenuCategoryTableViewCell.h"

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
//    PFObject *restaurant = [self.restaurantDetailArray objectAtIndex:indexPath.row];
//    for (NSString *category in [restaurant objectForKey:@"category"]) {
//        [self.menuCategory addObject:category];
//    }
//

    cell.courseName.text = self.menuCategory [indexPath.row];

    return cell;
}

-(IBAction)unwindToMenuCatagory:(UIStoryboardSegue*)sender
{

}

@end
