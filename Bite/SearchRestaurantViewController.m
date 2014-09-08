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
@property (strong, nonatomic) IBOutlet UIImageView *cellBackground;
@property (strong, nonatomic) IBOutlet UIImageView *forkImage;

@end

@implementation SearchRestaurantViewController

-(void)viewDidLoad{

    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
        [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    self.restaurantSearchField.text = nil;

}

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
    cell.cellBackground.layer.cornerRadius = 8.0;

    PFFile *imageFile = [restaurant objectForKey:@"restaurantImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.restaurantProfileImage.image = image;
            cell.restaurantProfileImage.layer.cornerRadius = cell.restaurantProfileImage.frame.size.height / 2;
            cell.restaurantProfileImage.clipsToBounds = YES;
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
    [self.forkImage setHidden:YES];

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

        checkInVC.restaurantObject = restaurant;
        
//        checkInVC.numberOfTables = [restaurant objectForKey:@"numberOfTables"];
//        checkInVC.tableCode = [restaurant objectForKey:@"tableCode"];
    }

}



@end
