//
//  LaunchPageViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "LaunchPageViewController.h"

@interface LaunchPageViewController ()

@end

@implementation LaunchPageViewController

+ (LaunchPageViewController *)newFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    return [storyboard instantiateViewControllerWithIdentifier:@"LaunchPageViewController"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}



@end
