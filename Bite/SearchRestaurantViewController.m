//
//  SearchRestaurantViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "SearchRestaurantViewController.h"
#import "LogInViewController.h"

@interface SearchRestaurantViewController ()

@end

@implementation SearchRestaurantViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    LogInViewController *loginVC;
    if (![PFUser currentUser])
    {
        [self presentViewController:loginVC animated:YES completion:^{
        }];
    }
    else {
    }
}

- (IBAction)unwindToSearch:(UIStoryboardSegue *)sender
{
}

@end
