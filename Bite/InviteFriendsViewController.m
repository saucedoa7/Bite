//
//  InviteFriendsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "CurrentBillViewController.h"

@interface InviteFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestLabel;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property NSMutableArray *theNewListOfStepperFriends;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property NSMutableArray *selectedRows;
@property NSArray *friends;
@property PFRelation *relationOfFriends;
@property double selectedGuestcounter;
@property double stepperGuestcounter;
@end

@implementation InviteFriendsViewController

#pragma mark View Did's

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listOfFriends = [NSMutableArray new];
    self.theNewListOfStepperFriends = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    UITableViewCell *cell;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    self.stepper.value = 0;
    self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter];
    self.listOfStepperFriends = 0;
    self.mergeArrays = NULL;
    NSLog(@"MergeCells in ViewWillAppear %@", self.mergeArrays);

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

-(void)viewDidDisappear:(BOOL)animated{
    //self.listOfStepperFriends = self.listOfStepperFriends;
    NSLog(@"IVC Did DisAppear %d", self.listOfStepperFriends);
}

#pragma mark TableViews Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendsCellID"];
    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];
    cell.textLabel.text = [friend objectForKey: @"username"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"SelectforRow");

    UITableViewCell *cell = [self.friendTableView cellForRowAtIndexPath:indexPath];
    if(![self.selectedRows containsObject:indexPath])
    {
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.listOfFriends addObject:cell.textLabel.text];
            self.selectedGuestcounter++;

        } else{
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.listOfFriends removeObject:cell.textLabel.text];

                self.selectedGuestcounter--;
            }
        }
        self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter + (int)self.stepperGuestcounter];

        self.mergeArrays = [self.listOfFriends arrayByAddingObjectsFromArray:self.theNewListOfStepperFriends];
        NSLog(@"Show Merge Guest after Sectected Cell: %@\n", self.mergeArrays);
        NSLog(@"List of Friends from Array %@", self.listOfFriends);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

#pragma mark IBActions

- (IBAction)onAddRemoveGuestButton:(UIStepper *)sender {
    self.stepperGuestcounter = [sender value];

    self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter + (int)self.stepperGuestcounter];
    self.listOfStepperFriends = (int) self.stepperGuestcounter;

    NSLog(@"Steppers in IVC %d\n", self.listOfStepperFriends);

    if (self.listOfStepperFriends > 0) {

        for (int i = self.listOfStepperFriends ; i == self.listOfStepperFriends; i++){

            NSString *str = [NSString stringWithFormat:@"Guest %d", (int)i];
            NSLog(@"Stepper Guest %@", str);

            [self.theNewListOfStepperFriends addObject:str];
            NSLog(@"New Stepper Guest %@", str);

            self.mergeArrays = [self.listOfFriends arrayByAddingObjectsFromArray:self.theNewListOfStepperFriends];
            NSLog(@"Show Merge Guest after Steppers: %@\n", self.mergeArrays);
        }
    }
}

- (IBAction)onAddGuestButton:(UIButton *)sender {
}

-(IBAction)unwindToInviteFrinds:(UIStoryboardSegue*)sender{
    
}
@end