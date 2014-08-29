//
//  CurrentBillViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CurrentBillViewController.h"
#import "CheckInToTableViewController.h"

@interface CurrentBillViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;

@end


@implementation CurrentBillViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onPaidButton:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *tableNumberString  = [NSString stringWithFormat:@"T:%d", self.tableNumber];
    self.tableLabel.text = tableNumberString;
    NSLog(@"tableLabel %@", self.tableLabel.text);
}


@end
