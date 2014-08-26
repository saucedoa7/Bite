//
//  SearchRestaurantViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "SearchRestaurantViewController.h"
#import "LaunchPageViewController.h"
#import "RestaurantSearchResultTableViewCell.h"

@interface SearchRestaurantViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *restaurantSearchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *restaurantSearchResult;

@end

@implementation SearchRestaurantViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showLaunchPageVC];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurantSearchResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCellID"];
    cell.restaurantNameLabel.text = @"Union Sushi";
    cell.cuisineLabel.text = @"Japanese";
    cell.addressLabel.text = @"222 W Erie St Chicago IL 60654";
    cell.addressLabel.text = @"12345678";
    return cell;

}



- (IBAction)onLogOutButtonPressed:(id)sender {
    [PFUser logOut];
    [self showLaunchPageVC];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.restaurantSearchField resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    PFQuery *restaurantQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantQuery whereKey:@"restaurantName" containsString:self.restaurantSearchField.text];
    [restaurantQuery  findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        }
        else {
            self.restaurantSearchResult = restaurantQuery;
        }

    }];

    [self.tableView reloadData];


}

- (IBAction)unwindToSearch:(UIStoryboardSegue *)sender
{
}

- (void) showLaunchPageVC
{
    if (![PFUser currentUser])
    {
        id launchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LaunchPageViewController"];
        [self presentViewController:launchVC animated:NO completion:nil];
    }

}

@end
