
//  CurrentBillViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.


#import "CurrentBillViewController.h"
#import "CheckInToTableViewController.h"
#import "InviteFriendsViewController.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
        self.owners = [[NSMutableArray alloc] initWithCapacity:self.tableBill.count];
        for (NSString *item in self.tableBill) {
            [self.owners addObject:@0];
        }
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
    [[self billTableView] reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count0 = 0;
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;
    for (NSNumber *number in self.owners) {
        if([number isEqualToNumber:@0]) {
            count0++;
        }
        if([number isEqualToNumber:@1]) {
            count1++;
        }
        if([number isEqualToNumber:@2]) {
            count2++;
        }
        if([number isEqualToNumber:@0]) {
            count3++;
        }
    }
    if (section == 0) {
        return count0;
    }
    if (section == 1) {
        return count1;
    }
    if (section == 2) {
        return count2;
    }
    if (section == 3) {
        return count3;
    }
    return self.tableBill.count;
//NSLog(@"table bill %@", self.tableBill.count);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCellID"];

    NSMutableArray *myArray = [NSMutableArray new];
    for (NSNumber *owner in self.owners) {
        if ([@(indexPath.section) isEqualToNumber:owner]) {
            [myArray addObject:[self.tableBill objectAtIndex:indexPath.row]];
        }
    }
    PFObject *billItem = [myArray objectAtIndex:indexPath.row];
    NSLog(@"billItem %@", billItem);

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"billCellID"];

    }

    PFObject *itemOrdered = [billItem objectForKey:@"itemOrdered"];
    [itemOrdered fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        cell.textLabel.text = [object objectForKey:@"foodItem"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: $%@.00",[object objectForKey:@"price"]];
    }];

    return cell;

}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.owners replaceObjectAtIndex:sourceIndexPath.row withObject:@(destinationIndexPath.section)];
    [self.billTableView reloadData];
//    PFObject *sourceBillItem = [self.tableBill objectAtIndex:sourceIndexPath.row];
//    PFObject *dstBillItem = [self.tableBill objectAtIndex:destinationIndexPath.row];
//    self.tableBill replaceObjectAtIndex:sourceIndexPath.row withObject:<#(id)#>
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

#pragma mark Add Section

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.mergeArrays count] + 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"WITHOUT OWNER";
    }
    return [self.mergeArrays objectAtIndex:section-1];
//    if ([self.billTableView isEditing]) {
//        return @"End of Group";
//    }
//    return nil;
}

#pragma mark Remove delete button

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
@end