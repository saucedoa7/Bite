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
@property IBOutlet UIButton *doneButton;
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

    self.doneButton.hidden = YES;

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.nameLabel.text = currentUser[FullName];
        self.emailLabel.text = currentUser.email;
        self.userNameLabel.text = currentUser.username;
    }

}

- (IBAction)onEditButton:(UIButton *)sender {
    [self showTextFields];
    [self hideLabels];
    self.doneButton.hidden = NO;

}

- (IBAction)onDoneButton:(UIButton *)sender {

   // PFUser *updateUser = [PFUser user];

    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;

    self.emailLabel.text = email;
    self.passwordLabel.text = password;
    self.userNameLabel.text = userName;

    [[PFUser currentUser] setUsername:userName];
    [[PFUser currentUser] setPassword:password];
    [[PFUser currentUser] setEmail:email];
    [[PFUser currentUser] saveInBackground];

    [self hideTextFields];
    [self showLabels];
}

#pragma mark - Hide/Show Textfields/Labels

- (void)showTextFields {
    self.emailTextField.hidden = NO;
    self.userNameTextField.hidden = NO;
    self.passwordTextField.hidden = NO;
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

-(IBAction)unwindToProfile:(UIStoryboardSegue *)sender
{

}
@end
