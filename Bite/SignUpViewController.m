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
    self.isSignIn = YES;
    [self refreshDisplay];


}

- (IBAction)onSignUpButtonPressed:(id)sender
{
    [self signUp];

}


- (void) refreshDisplay
{
    PFQuery *query = [PFQuery queryWithClassName:PersonClass];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        }
        else {
            self.personsArray = objects;
        }
    }];
}

#pragma mark - sign up
- (void) signUp {
    if (![self.usernameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""] && ![self.usernameTextField.text isEqualToString:@""] && ![self.emailTextField.text isEqualToString:@""]) {
        PFUser *user = [PFUser objectWithClassName:PersonClass];
        user[Username] = self.usernameTextField.text;
        user[Password] = self.passwordTextField.text;
        user[FullName] = self.nameTextField.text;
        user[Email] = self.emailTextField.text;
        [self.passwordTextField resignFirstResponder];

        BOOL taken = NO;

        for (PFUser *newUser in self.personsArray) {
            if ([newUser[Username] isEqualToString:user[Username]] || [newUser[Email] isEqualToString:user[Email]]) {
                taken = YES;
                UIAlertView *takeAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The email and/or username is already taken" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [takeAlert show];
                break;
            }

        }

        if (!taken) {
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alertView show];
                    NSLog(@"%@", [error userInfo]);
                }
                else
                {
                    [self refreshDisplay];
                }

            }];
        }
    }
    else {
        UIAlertView *emptyTextFieldAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"One or more fields are missing" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [emptyTextFieldAlert show];
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
