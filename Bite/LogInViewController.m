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
@property BOOL performSegueToMenu;

@property PFUser *user;
@property NSArray *personArray;

@end

@implementation LogInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender
{

}

- (IBAction)onLogInButtonPressed:(id)sender
{
//    for (PFUser *currentUser in self.personArray) {
//        NSString *userName = currentUser[Username];
//        NSString *password = currentUser[Password];
//        
//        if ([userName isEqualToString:self.usernameTextField.text] && [password isEqualToString:self.passwordTextField.text]) {
//            self.user = currentUser;
//            [self performSegueWithIdentifier:@"logInSegue" sender:self];
//        }
//    }

    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, and password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

        [alertView show];
    }
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self performSegueWithIdentifier:@"logInSegue" sender:self];
                NSLog(@"pass");
            }
        }];
    }
}

#pragma mark - segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"logInSegue"])
    {
        if (self.performSegueToMenu)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

@end
