//
//  AddFriendsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsTableViewCell.h"

#define Username @"username"

@interface AddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *friends;
@interface AddFriendsViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchFriends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AddFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendsCellID"];
    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];

    cell.textLabel.text = [friend objectForKey:Username];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.friends.count;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.friends = [NSMutableArray new];

    PFQuery *restaurantQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantQuery whereKey:@"restaurantName" containsString:self.restaurantSearchField.text];
    [restaurantQuery orderByAscending:@"restaurantName"];
    [restaurantQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = [objects mutableCopy];
        [self.tableView reloadData];
    }];
    [self.restaurantSearchField resignFirstResponder];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView reloadData];
}

-(IBAction)unwindToAddFriends:(UIStoryboardSegue*)sender
{
    
}

@end
