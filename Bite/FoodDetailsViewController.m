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

@end

@implementation FoodDetailsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemNameLabel.text = self.itemName;
    self.itemDescriptionLabel.text = self.itemDescription;

    PFFile *foodImageFile = self.foodImage;
    [foodImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.itemImage.image = [UIImage imageWithData:imageData];
        }
    }];

}



@end
