//
//  CategoryListViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CategoryListViewController.h"

@interface CategoryListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CategoryListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



@end
