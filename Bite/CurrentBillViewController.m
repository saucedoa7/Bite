//
//  CurrentBillViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CurrentBillViewController.h"
#import "CheckInToTableViewController.h"
#import "InviteFriendsViewController.h"

@interface CurrentBillViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *currentBillTable;
@property NSMutableArray *restaurantNames;
@property NSString *nameOfRest;
@property NSMutableArray *tableBill;
@property NSMutableArray *getBill;
@property NSNumber *tableNumberIntVal;
@property NSMutableArray *sectionsArray;
@end

@implementation CurrentBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listOfFriends = [NSMutableArray new];

    NSLog(@"List of Friends from Array VDL %@", self.listOfFriends);

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    self.tableNumberIntVal = [NSNumber numberWithInt:self.tableNumber];
}

- (IBAction)onPaidButton:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.listOfFriends = [NSMutableArray new];
    self.sectionsArray = [NSMutableArray new];

    //get data from other child tab bar
    InviteFriendsViewController *IVC = (InviteFriendsViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    self.listOfFriends = IVC.listOfFriends;
    self.mergeArrays = IVC.mergeArrays;
    NSLog(@"Steppers CBillVC %@\n", self.mergeArrays);


    [self.sectionsArray addObject:[NSString stringWithFormat:@"Merged Guests: %@", self.mergeArrays]];

#pragma mark CheckinTableView Data

    [[self billTableView] setDelegate:self];
    [[self billTableView] setDataSource:self];
    [[self billTableView] reloadData];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;

    self.tableBill = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Table"];
    [query whereKey:@"tableNumber" equalTo:self.tableNumberIntVal];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.tableBill = [objects mutableCopy];
        //        PFQuery *queryClass = [PFQuery queryWithClassName:@"Food"];
        //        [queryClass whereKey:@"itemsOrdered" equalTo:[PFObject objectWithClassName:@"Food"]];

    }];

    PFQuery *restaurantNameQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantNameQuery whereKey:@"restaurantPointer" equalTo:self.resaurantObject];
    [restaurantNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.restaurantNames = [objects mutableCopy];
            self.nameOfRest = [[self.restaurantNames valueForKey:@"restaurantName"] objectAtIndex:0] ;
            self.restaurantNameLabel.text = self.nameOfRest;
            [self.currentBillTable reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableBill.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"Table Number: %d", indexPath.row + 1];

    PFObject *billItem = [self.tableBill objectAtIndex:indexPath.row];
    PFObject *itemOrdered = [billItem objectForKey:@"itemOrdered"];
    [itemOrdered fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.textLabel.text = [object objectForKey:@"foodItem"];
    }];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"billCellID"];
    }

    return cell;
}


#pragma mark Drag Cells

//Drag Cells 1
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//Drag Cells 2
- (IBAction)onEditButton:(UIButton *)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.currentBillTable setEditing:NO animated:NO];
        [self.currentBillTable reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.currentBillTable setEditing:YES animated:YES];
        [self.currentBillTable reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

#pragma mark Add Section


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listOfFriends count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.listOfFriends objectAtIndex:section];
}

#pragma mark Remove delete button

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

@end
