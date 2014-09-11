//
//  TabBarController.m
//  Bite
//
//  Created by Albert Saucedo on 8/28/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "TabBarController.h"
#import "MenuCategoryViewController.h"
#import "CurrentBillViewController.h"

@interface TabBarController ()
@end

@implementation TabBarController
@synthesize tableNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MenuCategoryViewController *categoryVC = self.viewControllers[1];
    categoryVC.resaurantObject = self.restaurantObject;
    categoryVC.tableNumber = self.tableNumber;

    CurrentBillViewController *currentBillVC = self.viewControllers[2];
    currentBillVC.tableNumber = self.tableNumber;
    currentBillVC.resaurantObject = self.restaurantObject;
    self.navigationItem.hidesBackButton = YES;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    // If selected tab is 2
    //self.tabBarController.navigationController
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // MenuCategoryViewController *categoryVC = segue.destinationViewController;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    MenuCategoryViewController *menuVC = segue.destinationViewController;
    menuVC.resaurantObject = self.restaurantObject;

    CurrentBillViewController *currentBillVC = segue.destinationViewController;
    currentBillVC.resaurantObject = self.restaurantObject;
    currentBillVC.tableNumber = self.tableNumber;
}
@end