//
//  FriendsListViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "FriendsListViewController.h"

@interface FriendsListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property NSArray *friends;
@property PFRelation *relationOfFriends;
@end

@implementation FriendsListViewController
FriendsListViewController *friendList;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    PFQuery *queryForFriends = [[[PFUser currentUser] relationForKey:@"friendsRelation"] query];
    [queryForFriends orderByAscending:@"username"];
    [queryForFriends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        } else {
            self.friends = objects;
            [self.friendTableView reloadData];
            NSLog(@"username gf%@", self.friends);
            NSString *test = [self.friends objectAtIndex:0];
            NSLog(@"%@", test);
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendListCellID"];
    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];

    cell.textLabel.text = [friend objectForKey: @"username"];
    NSLog(@"%@", friend);
    return cell;

}

-(IBAction)unwindToFriendsList:(UIStoryboardSegue *)sender{
    
}

@end
