//
//  TableCheckInCodeViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "TableCheckInCodeViewController.h"
#import "TabBarController.h"

@interface TableCheckInCodeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property BOOL performSegue;

@property NSString *tableCode;


@end

@implementation TableCheckInCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.performSegue = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableCode = [self.restaurantObject objectForKey:@"tableCode"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarController *tabVC = segue.destinationViewController;
    tabVC.restaurantObject = self.restaurantObject;

}


@end
