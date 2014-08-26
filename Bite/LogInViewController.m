//
//  LogInViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

#define Username @"username"
#define Password @"password"

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LogInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.usernameTextField.text = nil;
    self.passwordTextField.text = nil;
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender
{

}

- (IBAction)onLogInButtonPressed:(id)sender
{


    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[[error.userInfo objectForKey:@"error"] capitalizedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                id searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchRestaurantViewController"];
                [self presentViewController:searchVC animated:NO completion:nil];
            }
        }];

    }
}


@end
