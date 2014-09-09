
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
@property (weak, nonatomic) IBOutlet UITableView *billTableView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property NSMutableArray *restaurantNames;
@property NSString *nameOfRest;
@property NSMutableArray *tableBill;
@property NSMutableArray *getBill;
@property NSNumber *tableNumberIntVal;
@property NSMutableArray *sectionsArray;
@property NSMutableArray *numberOfTablesMute;
@property NSMutableArray *prices;
@property NSMutableArray *owners;
@property (weak, nonatomic) IBOutlet UILabel *totalPricelabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property NSMutableArray *foodItems;
@end

@implementation CurrentBillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionsArray = [NSMutableArray new];
    self.mergeArrays = [NSMutableArray new];
    self.foodItems = [NSMutableArray new];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    self.tableNumberIntVal = [NSNumber numberWithInt:self.tableNumber];

    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.2 alpha:1];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    [self.tabBarController setTitle:@"Table Bill"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (IBAction)onPaidButton:(id)sender {
}

- (void)createArrays
{
    self.owners = [NSMutableArray new];
    [self.owners addObject:self.tableBill];
    [self.owners addObject:[NSMutableArray new]];
    for (NSString *string in self.mergeArrays) {
        [self.owners addObject:[NSMutableArray new]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.owners = [NSMutableArray new];
    InviteFriendsViewController *IVC = (InviteFriendsViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    self.mergeArrays = IVC.mergeArrays;

    [self.sectionsArray removeAllObjects];
    [self.sectionsArray addObject:[NSString stringWithFormat:@"Merged Guests: %@", self.mergeArrays]];

    [[self billTableView] setDelegate:self];
    [[self billTableView] setDataSource:self];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;

    self.tableBill = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Table"];
    [query whereKey:@"tableNumber" equalTo:self.tableNumberIntVal];
    [query whereKey:@"restaurantName" equalTo:self.resaurantObject];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.tableBill = [objects mutableCopy];
        __block int count = self.tableBill.count;
        __block float total = 0;
        for (PFObject *table in self.tableBill) {
            PFObject *food = [table objectForKey:@"itemOrdered"];
            [food fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [self.foodItems addObject:object];
                NSNumber *sub = [food objectForKey:@"price"];
                total += sub.floatValue;
                count--;
                if (count == 0) {
                    [self createArrays];
                    self.owners[0] = self.foodItems;
                    [self.billTableView reloadData];
                    self.totalPricelabel.text = [NSString stringWithFormat:@"%.2f",total];
                    NSLog(@"Total within Query %@", self.totalPricelabel.text);

                    self.taxLabel.text = [NSString stringWithFormat:@"%.2f", total * .1];
                    float floatTax = ([self.taxLabel.text floatValue]/100);
                    float floatTotal = [self.totalPricelabel.text floatValue];
                    NSLog(@"%.2f", floatTax);

                    float subTotal = (floatTotal * floatTax) + floatTotal;
                    NSLog(@"Total %.2f", floatTotal);
                    NSLog(@"Tax %.2f", floatTax);
                    NSString *stringSubtotal = [NSString stringWithFormat:@"%.2f", subTotal];
                    self.subtotalLabel.text = stringSubtotal;
                    NSLog(@"%.2f", subTotal);
                }
            }];

        }
    }];

    PFQuery *restaurantNameQuery = [PFQuery queryWithClassName:@"Restaurant"];
    [restaurantNameQuery whereKey:@"restaurantPointer" equalTo:self.resaurantObject];
    [restaurantNameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.restaurantNames = [objects mutableCopy];
            self.nameOfRest = [[self.restaurantNames valueForKey:@"restaurantName"] objectAtIndex:0];
            self.thankYouLabel.text = [NSString stringWithFormat:@"Thank you for dining at\n %@", self.nameOfRest];
            self.restaurantNameLabel.text = self.nameOfRest;
            [self.billTableView reloadData];
        }
    }];
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

    PFObject *itemOrdered = [array objectAtIndex:indexPath.row];
    cell.billItem.text = [itemOrdered objectForKey:@"foodItem"];
    cell.itemPrice.text = [NSString stringWithFormat:@"%@", [itemOrdered objectForKey:@"price"]];



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
        [self.editButton setTitle: @"Edit" forState: UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.billTableView setEditing:YES animated:YES];
        [self.editButton setTitle: @"Done" forState: UIControlStateNormal];
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
    [self.billTableView reloadData];
}

#pragma mark Add Section

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    __block float total = 0;

    NSArray *array = self.owners[section];
    for (PFObject *item in array) {
        NSNumber *price = [item objectForKey:@"price"];
        total += price.floatValue;
    }

    if (section == 0) {
        return [NSString stringWithFormat:@"Items ordered %.2f", total];
    } else if(section == 1) {
        return [NSString stringWithFormat:@"Me %.2f", total];
    }else {
        NSLog(@"ENTRO! %f", total);
        return [NSString stringWithFormat:@"%@ %.2f", [self.mergeArrays objectAtIndex:section-2],total];
    }

    [self.billTableView reloadData];
    return @"";
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