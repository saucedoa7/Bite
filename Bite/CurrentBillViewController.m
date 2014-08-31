//
//  CurrentBillViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CurrentBillViewController.h"
#import "CheckInToTableViewController.h"

@interface CurrentBillViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *currentBillTable;
@property NSMutableArray *restaurantNames;
@property NSString *nameOfRest;
@property NSMutableArray *tableBill;
@property NSNumber *tableNumberIntVal;

@end


@implementation CurrentBillViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table: %d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    self.tableNumberIntVal = [NSNumber numberWithInt:self.tableNumber];

}

- (IBAction)onPaidButton:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    NSString *tableNumberString  = [NSString stringWithFormat:@"Table :%d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    NSLog(@"tableLabel %@", self.tableLabel.text);

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

    return cell;
}


@end
