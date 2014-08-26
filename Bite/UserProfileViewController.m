//
//  UserProfileViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "UserProfileViewController.h"
#import <Parse/Parse.h>

#define Username @"username"
#define Password @"password"
#define FullName @"fullName"
#define Email @"email"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self hideTextFields];
    [self showPFCurrentUser];
    self.doneButton.hidden = YES;

}

- (IBAction)onEditButton:(UIButton *)sender {
    [self showTextFields];
    [self hideLabels];
    self.doneButton.hidden = NO;
}

- (IBAction)onDoneButton:(UIButton *)sender {

    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;

    self.emailLabel.text = email;
    self.userNameLabel.text = userName;

    [[PFUser currentUser] setUsername:userName];
    [[PFUser currentUser] setEmail:email];
    [PFUser currentUser].password = password;
    [[PFUser currentUser] saveInBackground];

    [self hideTextFields];
    [self showLabels];

    self.doneButton.hidden = YES;
}

#pragma mark - Hide/Show Textfields/Labels

- (void)showTextFields {

    self.emailTextField.hidden = NO;
    self.emailTextField.text = self.emailLabel.text;
    self.userNameTextField.hidden = NO;
    self.userNameTextField.text = self.userNameLabel.text;
    self.passwordTextField.hidden = NO;
    [self showPFCurrentUser];
}

- (void)hideTextFields
{
    self.emailTextField.hidden = YES;
    self.userNameTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
}

-(void)hideLabels{
    self.userNameLabel.hidden = YES;
    self.emailLabel.hidden = YES;
    self.passwordLabel.hidden = YES;
}

-(void)showLabels{
    self.userNameLabel.hidden = NO;
    self.emailLabel.hidden = NO;
    self.passwordLabel.hidden = NO;
}

#pragma mark PFUser

-(void)showPFCurrentUser{

    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = currentUser[FullName];
    self.emailLabel.text = currentUser.email;
    self.userNameLabel.text = currentUser.username;
    self.passwordLabel.text = @"*****";
}

-(IBAction)unwindToProfile:(UIStoryboardSegue *)sender
{

}
@end
