//
//  TableCheckInCodeViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "TableCheckInCodeViewController.h"
#import "TabBarController.h"

@interface TableCheckInCodeViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property BOOL performSegue;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property NSString *tableCode;


@end

@implementation TableCheckInCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.performSegue = NO;
    self.codeTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableCode = [self.restaurantObject objectForKey:@"tableCode"];

    
}

-(void)showAnimation {

    [self.view addSubview:self.mainView];
    self.mainView.frame = CGRectMake(0, -75, 320, 560); // somewhere offscreen, in the direction you want it to appear from
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.mainView.frame = CGRectMake(0, -75, 320, 560); // its final location
                     }];
}

- (IBAction)onNextButtonPressed:(id)sender {

    if ([self.codeTextField.text length] == 0 || ![self.codeTextField.text isEqualToString: self.tableCode]) {
        UIAlertView *inputCodeAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Invalid code, please try again or use a different code"
                                                                delegate:self cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.codeTextField resignFirstResponder];
    return YES;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabBarController *tabVC = segue.destinationViewController;
    tabVC.restaurantObject = self.restaurantObject;
    tabVC.tableNumber = self.tableNumber;
    
}

@end
