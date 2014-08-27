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
#define UserClass @"User"

@interface AddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property NSMutableArray *friends;
@property (strong, nonatomic) IBOutlet UISearchBar *searchFriends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AddFriendsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendsCellID"];
    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];

    cell.textLabel.text = [friend objectForKey:Username];

    NSLog(@"%@", cell.textLabel.text);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.friends = [NSMutableArray new];

    PFQuery *findFriendQuery = [PFUser query];
    NSLog(@"TEst %@", self.searchFriends.text);

    [findFriendQuery whereKey:Username containsString:self.searchFriends.text];
    [findFriendQuery orderByAscending:Username];
    [findFriendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
        self.friends = [objects mutableCopy];
        [self.tableView reloadData];
    }];


    [self.searchFriends resignFirstResponder];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView reloadData];
}

-(IBAction)unwindToAddFriends:(UIStoryboardSegue*)sender
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@""]) {
        //as
    }
}

@end
