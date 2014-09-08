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

@interface SignUpViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
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
    self.usernameTextField.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    self.passwordTextField.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    self.nameTextField.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    self.emailTextField.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    [self.usernameTextField setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextField setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailTextField setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.usernameTextField.delegate = self;
}

- (IBAction)onSignUpButtonPressed:(id)sender
{
    [self signUp];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    return YES;
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
        newUser[FullName] = fullName;
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self dismissViewControllerAnimated:YES completion:nil];
//            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
            }
        }];
    }
    
}

@end
