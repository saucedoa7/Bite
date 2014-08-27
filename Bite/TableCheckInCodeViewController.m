//
//  TableCheckInCodeViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "TableCheckInCodeViewController.h"

@interface TableCheckInCodeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property BOOL performSegue;

@end

@implementation TableCheckInCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.performSegue = NO;
    
}

- (IBAction)onNextButtonPressed:(id)sender {

    if ([self.codeTextField.text length] == 0 || ![self.codeTextField.text isEqualToString: self.tableCode]) {
        UIAlertView *inputCodeAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid code, please try again or use a different code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [inputCodeAlert show];
    }
    else {
        self.performSegue = YES;

    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"codeEnteredSegue"])
    {
        if (self.performSegue)
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
