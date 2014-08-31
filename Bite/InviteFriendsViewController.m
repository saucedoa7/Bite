//
//  InviteFriendsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "InviteFriendsViewController.h"

@interface InviteFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestLabel;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property NSMutableArray *selectedRows;
@property NSArray *friends;
@property PFRelation *relationOfFriends;
@property double selectedGuestcounter;
@property double stepperGuestcounter;
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSMutableArray new];
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
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendsCellID"];
    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];
    cell.textLabel.text = [friend objectForKey: @"username"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.friendTableView cellForRowAtIndexPath:indexPath];
    if(![self.selectedRows containsObject:indexPath])
    {
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedGuestcounter++;

        } else{
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                self.selectedGuestcounter--;
        }

    }

    self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter + (int)self.stepperGuestcounter];
}
}
- (IBAction)onAddRemoveGuestButton:(UIStepper *)sender {
    self.stepperGuestcounter = [sender value];
    self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter + (int)self.stepperGuestcounter];
}
- (IBAction)onAddGuestButton:(UIButton *)sender {
}

-(IBAction)unwindToInviteFrinds:(UIStoryboardSegue*)sender{
    
}
@end
