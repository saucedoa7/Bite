//
//  ForgotPasswordViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailTextField.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    [self.emailTextField setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    self.emailTextField.delegate = self;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = self.view.frame;
    frame.origin.y = -100; // new y coordinate

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    self.view.frame = frame;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    CGRect frame = self.view.frame;
    frame.origin.y = 0; // new y coordinate

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.35];
    self.view.frame = frame;
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.emailTextField resignFirstResponder];
    return YES;
}

- (IBAction)onRequestButton:(UIButton *)sender {
    if ([self.emailTextField.text isEqualToString: @""]) {
        UIAlertView *emailAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email address to proceed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailAlertView show];
    }
    else {
        NSString *email = self.emailTextField.text;
        NSLog(@"My email is: %@", email);
        [PFUser requestPasswordResetForEmailInBackground:email];
    }
}
@end
