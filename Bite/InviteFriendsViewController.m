//
//  InviteFriendsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "CurrentBillViewController.h"

@interface InviteFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGuestLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property NSMutableArray *theNewListOfStepperFriends;
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

    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.2 alpha:1];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated{

    self.listOfFriends = [NSMutableArray new];
    self.theNewListOfStepperFriends = [NSMutableArray new];

    self.selectedGuestcounter = 0;
    self.numberOfGuestLabel.text = @"0";
    [self.theNewListOfStepperFriends removeAllObjects];
    [self.listOfFriends removeAllObjects];

    [[self friendTableView] setDelegate:self];
    [[self friendTableView] setDataSource:self];
    [[self friendTableView] reloadData];

    [super viewWillAppear:YES];

    [self.friendTableView deselectRowAtIndexPath:[self.friendTableView indexPathForSelectedRow] animated:YES];

    self.stepper.value = 0;

    NSLog(@"Stepper.Value %f", self.stepper.value);

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

    [self.tabBarController setTitle:@"Guests"];

}

-(void)viewWillDisappear:(BOOL)animated{

    NSLog(@"Will DISS list of selected should be cleared %@", self.theNewListOfStepperFriends);

    NSLog(@"WILL DISS The new list of steppers should be cleared %@", self.theNewListOfStepperFriends);

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [viewController.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark TableViews Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addFriendsCellID"];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.listOfFriends removeObject:cell.textLabel.text];
        self.numberOfGuestLabel.text = @"0";
        NSLog(@"number of guest label 1 %@", self.numberOfGuestLabel.text);
    }


    PFObject *friend = [self.friends  objectAtIndex:indexPath.row];
    cell.textLabel.text = [friend objectForKey: @"username"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"SelectforRow");

    [self.friendTableView deselectRowAtIndexPath:[self.friendTableView indexPathForSelectedRow] animated:YES];


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
        NSLog(@"number of guest label 2 %@", self.numberOfGuestLabel.text);

    }

    self.mergeArrays = [self.listOfFriends arrayByAddingObjectsFromArray:self.theNewListOfStepperFriends];
    NSLog(@"Show Merge Guest after Sectected Cell: %@\n", self.mergeArrays);
    NSLog(@"List of Friends from Array %@", self.listOfFriends);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friends.count;
}

#pragma mark IBActions

- (IBAction)onAddRemoveGuestButton:(UIStepper *)sender {
    self.stepperGuestcounter = [sender value];
    self.listOfStepperFriends = 0;
    self.numberOfGuestLabel.text = [NSString stringWithFormat:@"%d", (int)self.selectedGuestcounter + (int)self.stepperGuestcounter];
    NSLog(@"number of guest label 3 %@", self.numberOfGuestLabel.text);

    self.listOfStepperFriends = (int) self.stepperGuestcounter;

    NSLog(@"Steppers in IVC %d\n", self.listOfStepperFriends);

    if (self.listOfStepperFriends > 0) {

        for (int i = self.listOfStepperFriends ; i == self.listOfStepperFriends; i++){

            NSString *str = [NSString stringWithFormat:@"Guest %d", (int)i];
            NSLog(@"Stepper String Guest %@", str);

            [self.theNewListOfStepperFriends addObject:str];
            NSLog(@"The New List of Stepper Guest %@", str);

            self.mergeArrays = [self.listOfFriends arrayByAddingObjectsFromArray:self.theNewListOfStepperFriends];
            NSLog(@"Show Merge Guest after Steppers: %@\n", self.mergeArrays);
        }
    }
}

-(IBAction)unwindToInviteFrinds:(UIStoryboardSegue*)sender{
    
}
@end