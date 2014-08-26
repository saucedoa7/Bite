//
//  SignUpViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

#define PersonClass @"Person"
#define Username @"username"
#define Password @"password"
#define FullName @"fullName"
#define Email @"email"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property BOOL performSegueToMenu;

@property NSArray *personsArray;
@property BOOL isSignIn;
@property PFUser *user;

@end

@implementation SignUpViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.performSegueToMenu = NO;


}

- (IBAction)onSignUpButtonPressed:(id)sender
{
    [self signUp];

}


#pragma mark - sign up
- (void) signUp {

    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *fullName = self.nameTextField.text;

    if ([username length] == 0 || [password length] == 0 || [email length] == 0 || [fullName length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid username, password, and email address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    } else {

        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser[FullName] = self.nameTextField.text;
        newUser.email = email;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                self.performSegueToMenu = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}


#pragma mark - segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"signUpSegue"])
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
