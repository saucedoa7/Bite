//
//  MenuCategoryViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "MenuCategoryViewController.h"
#import "MenuCategoryTableViewCell.h"

@interface MenuCategoryViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MenuCategoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(IBAction)unwindToMenuCatagory:(UIStoryboardSegue*)sender
{

}

@end
