//
//  SearchRestaurantViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "SearchRestaurantViewController.h"
#import "LaunchPageViewController.h"

@interface SearchRestaurantViewController ()

@end

@implementation SearchRestaurantViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self showLaunchPageVC];
}

- (IBAction)onLogOutButtonPressed:(id)sender {
    [PFUser logOut];
    [self showLaunchPageVC];

}

- (IBAction)unwindToSearch:(UIStoryboardSegue *)sender
{
}

- (void) showLaunchPageVC
{
    if (![PFUser currentUser])
    {
        id launchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LaunchPageViewController"];
        [self presentViewController:launchVC animated:NO completion:nil];
    }

}

@end
