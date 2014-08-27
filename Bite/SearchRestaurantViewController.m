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
#import "CheckInToTableViewController.h"

@interface SearchRestaurantViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *restaurantSearchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *restaurantSearchResult;
@property NSNumber *numberOfTables;

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
    PFObject *restaurant = [self.restaurantSearchResult objectAtIndex:indexPath.row];

    PFFile *imageFile = [restaurant objectForKey:@"restaurantImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.RestaurantProfileImage.image = image;
        }
    }];

    cell.restaurantNameLabel.text = [restaurant objectForKey:@"restaurantName"];
    cell.cuisineLabel.text = [restaurant objectForKey:@"cuisine"];
    cell.addressLabel.text = [restaurant objectForKey:@"restaurantAddress"];
    cell.contactNumberLabel.text = [restaurant objectForKey:@"phoneNumber"];
    return cell;
}

- (IBAction)onLogOutButtonPressed:(id)sender {
    [PFUser logOut];
    [self showLaunchPageVC];

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.restaurantSearchResult = [NSMutableArray new];

    PFQuery *restaurantQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantQuery whereKey:@"restaurantName" containsString:self.restaurantSearchField.text];
    [restaurantQuery orderByAscending:@"restaurantName"];
    [restaurantQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.restaurantSearchResult = [objects mutableCopy];
        [self.tableView reloadData];
    }];
    [self.restaurantSearchField resignFirstResponder];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"checkInSegue"]) {
        CheckInToTableViewController *checkInVC = segue.destinationViewController;
        PFObject *restaurant = [self.restaurantSearchResult objectAtIndex:self.tableView.indexPathForSelectedRow.row];

        checkInVC.numberOfTables = [restaurant objectForKey:@"numberOfTables"];
        checkInVC.tableCode = [restaurant objectForKey:@"tableCode"];
    }

}

@end
