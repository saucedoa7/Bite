
//  CurrentBillViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.


#import "CurrentBillViewController.h"
#import "CheckInToTableViewController.h"
#import "InviteFriendsViewController.h"
#import "BillTableViewCell.h"

@interface CurrentBillViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property NSMutableArray *restaurantNames;
@property NSString *nameOfRest;
@property NSMutableArray *tableBill;
@property NSMutableArray *getBill;
@property NSNumber *tableNumberIntVal;
@property NSMutableArray *sectionsArray;
@property NSMutableArray *numberOfTablesMute;

@property NSMutableArray *owners;
@end

@implementation CurrentBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionsArray = [NSMutableArray new];
    self.mergeArrays = [NSMutableArray new];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    self.tableNumberIntVal = [NSNumber numberWithInt:self.tableNumber];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}

- (IBAction)onPaidButton:(id)sender {
}

- (void)createArrays
{
    if (!self.owners) {
        self.owners = [NSMutableArray new];
        [self.owners addObject:self.tableBill];
        for (NSString *string in self.mergeArrays) {
            NSLog(@"owner %@", string);
            [self.owners addObject:[NSMutableArray new]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];


    [self.billTableView reloadData];

    //get data from other child tab bar
    InviteFriendsViewController *IVC = (InviteFriendsViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
        NSLog(@"0 Steppers CBillVC %@\n", IVC.mergeArrays);
        self.mergeArrays = IVC.mergeArrays;
        NSLog(@"1 Steppers CBillVC %@\n", IVC.mergeArrays);


    [self.sectionsArray removeAllObjects];
    NSLog(@"ViewWillAppear %@", self.sectionsArray);

    [self.sectionsArray addObject:[NSString stringWithFormat:@"Merged Guests: %@", self.mergeArrays]];

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
        [self createArrays];
        [self.billTableView reloadData];
    }];

    PFQuery *restaurantNameQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantNameQuery whereKey:@"restaurantPointer" equalTo:self.resaurantObject];
    [restaurantNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.restaurantNames = [objects mutableCopy];
            self.nameOfRest = [[self.restaurantNames valueForKey:@"restaurantName"] objectAtIndex:0];
            self.restaurantNameLabel.text = self.nameOfRest;
            [self.billTableView reloadData];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [self.owners objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCellID"];

    if (!cell) {
        cell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"billCellID"];

    }
    NSMutableArray *array = [self.owners objectAtIndex:indexPath.section];
    PFObject *itemOrdered = [[array objectAtIndex:indexPath.row] objectForKey:@"itemOrdered"];
    NSLog(@"itemOrdered %@", itemOrdered);
    [itemOrdered fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.billItem.text = [object objectForKey:@"foodItem"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: $%@.00",[object objectForKey:@"price"]];
    }];
    return cell;
}

#pragma mark Drag Cells

//Drag Cells 1
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//Drag Cells 2
- (IBAction)onEditButton:(UIBarButtonItem *)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.billTableView setEditing:NO animated:NO];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.billTableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

//Drag Cells 3
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *originArray = [self.owners objectAtIndex:sourceIndexPath.section];
    NSMutableArray *destinyArray = [self.owners objectAtIndex:destinationIndexPath.section];
    [destinyArray addObject:[originArray objectAtIndex:sourceIndexPath.row]];
    [originArray removeObjectAtIndex:sourceIndexPath.row];
    //[self.billTableView reloadData];
}

#pragma mark Add Section


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Me";
    }
    return [self.mergeArrays objectAtIndex:section-1];
}

#pragma mark Remove delete button

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

#pragma mark Add Section

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.owners.count;
}
@end