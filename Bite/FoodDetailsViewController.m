//
//  FoodDetailsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "FoodDetailsViewController.h"
#import <MessageUI/MessageUI.h>


@interface FoodDetailsViewController () <UITextFieldDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *itemDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property PFObject *foodItemOrdered;
@property NSNumber *tableNumberIntVal;
@property (strong, nonatomic) IBOutlet UITextField *specialInstructionsLabel;
@property NSString *emailString;


@end

@implementation FoodDetailsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.specialInstructionsLabel.delegate = self;
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.2 alpha:1];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];

    self.tableNumberIntVal = [NSNumber numberWithInt:self.tableNumber];
    self.itemNameLabel.text = [self.foodItemSelected objectForKey:@"foodItem"];
    self.itemDescriptionLabel.text = [self.foodItemSelected objectForKey:@"itemDescription"];
    self.itemPriceLabel.text = [NSString stringWithFormat:@"$%@", [self.foodItemSelected objectForKey:@"price"]];

    PFFile *foodImageFile = [self.foodItemSelected objectForKey:@"foodImage"];
    [foodImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.itemImage.image = [UIImage imageWithData:imageData];
            self.itemImage.layer.cornerRadius = self.itemImage.frame.size.width / 2;
            self.itemImage.clipsToBounds = YES;
        }
    }];



    PFObject *restaurant = [self.foodItemSelected objectForKey:@"restaurant"];
    [restaurant fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.emailString = [object objectForKey:@"email"];
        NSLog(@"email %@", self.emailString);
    }];


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.specialInstructionsLabel resignFirstResponder];
    return YES;
}

- (IBAction)onAddButtonPressed:(id)sender {
    self.foodItemOrdered =self.foodItemSelected;
    PFObject *saveOrder = [PFObject objectWithClassName:@"Table"];
    [saveOrder setObject:self.foodItemOrdered forKey:@"itemOrdered"];
    [saveOrder setObject:self.tableNumberIntVal forKey:@"tableNumber"];
    [saveOrder setObject:[self.foodItemOrdered objectForKey:@"restaurant"] forKey:@"restaurantName"];
    [saveOrder setObject:self.specialInstructionsLabel.text forKey:@"specialInstructions"];
    [saveOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];

    NSString *emailTitle = [NSString stringWithFormat:@"Item Order For Table: %d",self.tableNumber];

    NSString *messageBody = [NSString stringWithFormat:@"Item Ordered: %@\n Special Instructions: %@", self.itemNameLabel.text, self.specialInstructionsLabel.text];

    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.emailString];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];


}




@end
