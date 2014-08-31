//
//  FoodDetailsViewController.m
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "FoodDetailsViewController.h"

@interface FoodDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *itemDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property NSMutableArray *foodItemOrdered;


@end

@implementation FoodDetailsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemNameLabel.text = [self.foodItemSelected objectForKey:@"foodItem"];
    self.itemDescriptionLabel.text = [self.foodItemSelected objectForKey:@"itemDescription"];
    self.itemPriceLabel.text = [NSString stringWithFormat:@"$%@.00", [self.foodItemSelected objectForKey:@"price"]];

    PFFile *foodImageFile = [self.foodItemSelected objectForKey:@"foodImage"];
    [foodImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.itemImage.image = [UIImage imageWithData:imageData];
        }
    }];

}

- (IBAction)onAddButtonPressed:(id)sender {
    self.foodItemOrdered = [NSMutableArray new];
    [self.foodItemOrdered addObject:self.foodItemSelected];
    PFObject *saveOrder = [PFObject objectWithClassName:@"Table"];
    [saveOrder setObject:self.foodItemOrdered forKey:@"itemsOrdered"];
    [saveOrder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        }
    }];

}


@end
